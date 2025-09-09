.PHONY: help example-1 example-1-down example-1-logs example-1-status example-1-rebuild example-1-test example-1-kill-app-a example-1-start-app-a example-2 example-2-down example-2-logs example-2-status example-2-shell example-2-kill-region example-2-start-region example-2-test example-3 example-3-down example-3-logs example-3-status example-3-rebuild example-3-set-value example-3-get-value example-3-kill-node2 example-3-start-node2

# Diretório do exemplo 1
EXAMPLE_1_DIR = examples/1-load-balance-with-containers-simulating-failures
# Diretório do exemplo 2
EXAMPLE_2_DIR = examples/2-load-balance-and-replication
# Diretório do exemplo 3
EXAMPLE_3_DIR = examples/3-example-eventual-consistency

# Define o comando padrão quando apenas 'make' é executado
.DEFAULT_GOAL := help

# Detecta se estamos no Windows para configurar a codificação corretamente
ifeq ($(OS),Windows_NT)
	# No Windows, precisamos configurar o terminal para usar a codificação correta
	SHELL = cmd
	# Configura a codificação para UTF-8 ou Code Page 1252 (Latin1) que suporta acentos
	UTF8_CONFIG = @chcp 65001 >nul
	ECHO_BLANK = @echo.
else
	UTF8_CONFIG =
	ECHO_BLANK = @echo
	# Uso de bash é necessário para alguns comandos
	SHELL = /bin/bash
endif

## Exibe informações de ajuda para comandos disponíveis
help:
	$(UTF8_CONFIG)
	$(ECHO_BLANK)
	@echo "Distributed Systems Tech Talk - Makefile Commands"
	@echo "================================================="
	$(ECHO_BLANK)
	@echo "=== Exemplo 1: Load Balancing com Containers ==="
	$(ECHO_BLANK)
	@echo "  example-1            - Inicia o exemplo 1 (load balancing com containers e simulacao de falhas)"
	@echo "  example-1-down       - Para os containers do exemplo 1"
	@echo "  example-1-logs       - Exibe logs em tempo real dos containers do exemplo 1"
	@echo "  example-1-status     - Exibe o status dos containers do exemplo 1"
	@echo "  example-1-rebuild    - Reconstroi e reinicia os containers do exemplo 1"
	@echo "  example-1-test       - Testa o exemplo 1 fazendo uma requisicao para o balanceador de carga"
	@echo "  example-1-kill-app-a - Mata o container app-a para simular falha"
	@echo "  example-1-start-app-a - Reinicia o container app-a apos ter sido parado"
	$(ECHO_BLANK)
	@echo "=== Exemplo 2: Load Balancing e Replicacao com HBase ==="
	$(ECHO_BLANK)
	@echo "  example-2            - Inicia o exemplo 2 (HBase com replicacao)"
	@echo "  example-2-down       - Para os containers do exemplo 2"
	@echo "  example-2-logs       - Exibe logs em tempo real dos containers do exemplo 2"
	@echo "  example-2-status     - Exibe o status dos containers do exemplo 2"
	@echo "  example-2-shell      - Acessa o shell do HBase para interagir com o cluster"
	@echo "  example-2-kill-region - Para o container region1 para simular falha"
	@echo "  example-2-start-region - Reinicia o container region1 apos ter sido parado"
	@echo "  example-2-test       - Exibe dados na tabela users para testar a replicacao"
	$(ECHO_BLANK)
	@echo "=== Exemplo 3: Consistencia Eventual entre Nodes ==="
	$(ECHO_BLANK)
	@echo "  example-3            - Inicia o exemplo 3 (consistencia eventual entre nodes)"
	@echo "  example-3-down       - Para os containers do exemplo 3"
	@echo "  example-3-logs       - Exibe logs em tempo real dos containers do exemplo 3"
	@echo "  example-3-status     - Exibe o status dos containers do exemplo 3"
	@echo "  example-3-rebuild    - Reconstroi e reinicia os containers do exemplo 3"
	@echo "  example-3-set-value  - Grava um valor no node1"
	@echo "  example-3-get-value  - Verifica o valor armazenado no node2"
	@echo "  example-3-kill-node2 - Para o container node2 para simular falha"
	@echo "  example-3-start-node2 - Reinicia o container node2 apos ter sido parado"
	$(ECHO_BLANK)

## Inicia o exemplo 1 (load balancing com containers e simulação de falhas)
example-1:
	$(UTF8_CONFIG)
	@echo "Iniciando o exemplo 1: Load Balancing com Containers..."
	@docker-compose -f $(EXAMPLE_1_DIR)/docker-compose.yml up -d
	@echo "Containers iniciados! Acesse http://localhost:8080 para testar a aplicacao."
	@echo "Use 'make example-1-logs' para ver os logs em tempo real."
	@echo "Use 'make example-1-down' para parar os containers."

## Para os containers do exemplo 1
example-1-down:
	$(UTF8_CONFIG)
	@echo "Parando containers do exemplo 1..."
	@docker-compose -f $(EXAMPLE_1_DIR)/docker-compose.yml down
	@echo "Containers parados com sucesso."

## Exibe logs em tempo real dos containers do exemplo 1
example-1-logs:
	$(UTF8_CONFIG)
	@echo "Exibindo logs do exemplo 1 (Ctrl+C para sair)..."
	@docker-compose -f $(EXAMPLE_1_DIR)/docker-compose.yml logs -f

## Exibe o status dos containers do exemplo 1
example-1-status:
	$(UTF8_CONFIG)
	@echo "Status dos containers do exemplo 1:"
	@docker-compose -f $(EXAMPLE_1_DIR)/docker-compose.yml ps

## Reconstrói e reinicia os containers do exemplo 1
example-1-rebuild:
	$(UTF8_CONFIG)
	@echo "Reconstruindo containers do exemplo 1..."
	@docker-compose -f $(EXAMPLE_1_DIR)/docker-compose.yml down
	@docker-compose -f $(EXAMPLE_1_DIR)/docker-compose.yml build --no-cache
	@docker-compose -f $(EXAMPLE_1_DIR)/docker-compose.yml up -d
	@echo "Containers reconstruidos e iniciados com sucesso."

## Testa o exemplo 1 fazendo uma requisição para o balanceador de carga
example-1-test:
	$(UTF8_CONFIG)
	@echo "Testando o exemplo 1 (enviando requisicao para http://localhost:8080)..."
	@curl -s http://localhost:8080; if [ $$? -ne 0 ]; then echo "Erro ao fazer requisicao. Verifique se os containers estao rodando com 'make example-1-status'"; exit 1; fi
	$(ECHO_BLANK)

## Mata o container app-a para simular falha
example-1-kill-app-a:
	$(UTF8_CONFIG)
	@echo "Matando o container app-a para simular falha no servidor..."
	@docker-compose -f $(EXAMPLE_1_DIR)/docker-compose.yml stop app-a
	@echo "Container app-a parado com sucesso."
	@echo "Use 'make example-1-test' para verificar que o nginx esta redirecionando todas as requisicoes para o app-b."
	@echo "Use 'make example-1-status' para verificar o status dos containers."
	@echo "Use 'make example-1-start-app-a' para reiniciar o container app-a."

## Reinicia o container app-a após ter sido parado
example-1-start-app-a:
	$(UTF8_CONFIG)
	@echo "Reiniciando o container app-a..."
	@docker-compose -f $(EXAMPLE_1_DIR)/docker-compose.yml start app-a
	@echo "Container app-a reiniciado com sucesso."
	@echo "Use 'make example-1-test' varias vezes para verificar o balanceamento de carga entre os servidores."
	@echo "Use 'make example-1-status' para verificar o status dos containers."

## Inicia o exemplo 2 (HBase com replicação)
example-2:
	$(UTF8_CONFIG)
	@echo "Iniciando o exemplo 2: Load Balancing e Replicacao com HBase..."
	@docker-compose -f $(EXAMPLE_2_DIR)/docker-compose.yml up -d
	@echo "Containers iniciados! Aguarde alguns instantes para que o HBase esteja pronto."
	@echo "Acesse o HBase Master UI em http://localhost:16010 para visualizar o cluster."
	@echo "Use 'make example-2-shell' para acessar o shell do HBase."
	@echo "Use 'make example-2-logs' para ver os logs em tempo real."
	@echo "Use 'make example-2-down' para parar os containers."

## Para os containers do exemplo 2
example-2-down:
	$(UTF8_CONFIG)
	@echo "Parando containers do exemplo 2..."
	@docker-compose -f $(EXAMPLE_2_DIR)/docker-compose.yml down
	@echo "Containers parados com sucesso."

## Exibe logs em tempo real dos containers do exemplo 2
example-2-logs:
	$(UTF8_CONFIG)
	@echo "Exibindo logs do exemplo 2 (Ctrl+C para sair)..."
	@docker-compose -f $(EXAMPLE_2_DIR)/docker-compose.yml logs -f

## Exibe o status dos containers do exemplo 2
example-2-status:
	$(UTF8_CONFIG)
	@echo "Status dos containers do exemplo 2:"
	@docker-compose -f $(EXAMPLE_2_DIR)/docker-compose.yml ps

## Acessa o shell do HBase para interagir com o cluster
example-2-shell:
	$(UTF8_CONFIG)
	@echo "Acessando o shell do HBase..."
	@echo "Para criar uma tabela com replicacao, digite: create 'users', {NAME => 'info', REPLICATION_SCOPE => '1'},  SPLITS => ['user3', 'user6', 'user9']"
	@echo "Para inserir dados, digite: put 'users', 'user1', 'info:name', 'Alice'"
	@echo "Para ver os dados, digite: scan 'users'"
	@echo "Para sair, digite: exit"
	@docker exec -it hbase-master hbase shell

## Para o container region1 para simular falha
example-2-kill-region:
	$(UTF8_CONFIG)
	@echo "Parando o container region1 para simular falha no servidor..."
	@docker stop hbase-region1
	@echo "Container region1 parado com sucesso."
	@echo "Acesse o HBase Master UI (http://localhost:16010) para verificar a mudanca."
	@echo "Use 'make example-2-shell' e depois 'scan users' para verificar que os dados ainda estao disponiveis."

## Reinicia o container region1 após ter sido parado
example-2-start-region:
	$(UTF8_CONFIG)
	@echo "Reiniciando o container region1..."
	@docker start hbase-region1
	@echo "Container region1 reiniciado com sucesso."
	@echo "Aguarde alguns instantes para que o HBase region server esteja online novamente."

## Exibe dados na tabela users para testar a replicação
example-2-test:
	$(UTF8_CONFIG)
	@echo "Executando teste de replicacao - consultando dados da tabela 'users'..."
	@docker exec -it hbase-master hbase shell -n "scan 'users'" || echo "Erro: verifique se o cluster está ativo e se a tabela 'users' foi criada."

## Inicia o exemplo 3 (consistência eventual entre nodes)
example-3:
	$(UTF8_CONFIG)
	@echo "Iniciando o exemplo 3: Consistencia Eventual entre Nodes..."
	@docker-compose -f $(EXAMPLE_3_DIR)/docker-compose.yml up -d
	@echo "Containers iniciados! Aguarde alguns instantes para que os nodes estejam prontos."
	@echo "Use 'make example-3-set-value' para gravar um valor no node1."
	@echo "Use 'make example-3-get-value' para verificar se o valor foi replicado para o node2."
	@echo "Use 'make example-3-logs' para ver os logs em tempo real."
	@echo "Use 'make example-3-down' para parar os containers."

## Para os containers do exemplo 3
example-3-down:
	$(UTF8_CONFIG)
	@echo "Parando containers do exemplo 3..."
	@docker-compose -f $(EXAMPLE_3_DIR)/docker-compose.yml down
	@echo "Containers parados com sucesso."

## Exibe logs em tempo real dos containers do exemplo 3
example-3-logs:
	$(UTF8_CONFIG)
	@echo "Exibindo logs do exemplo 3 (Ctrl+C para sair)..."
	@docker-compose -f $(EXAMPLE_3_DIR)/docker-compose.yml logs -f

## Exibe o status dos containers do exemplo 3
example-3-status:
	$(UTF8_CONFIG)
	@echo "Status dos containers do exemplo 3:"
	@docker-compose -f $(EXAMPLE_3_DIR)/docker-compose.yml ps

## Reconstrói e reinicia os containers do exemplo 3
example-3-rebuild:
	$(UTF8_CONFIG)
	@echo "Reconstruindo containers do exemplo 3..."
	@docker-compose -f $(EXAMPLE_3_DIR)/docker-compose.yml down
	@docker-compose -f $(EXAMPLE_3_DIR)/docker-compose.yml build --no-cache
	@docker-compose -f $(EXAMPLE_3_DIR)/docker-compose.yml up -d
	@echo "Containers reconstruidos e iniciados com sucesso."

## Grava um valor no node1
example-3-set-value:
	$(UTF8_CONFIG)
	@echo "Gravando valor 'Versao1' para a chave 'mensagem' no node1..."
	@curl -s -X POST -H "Content-Type: application/json" -d "{\"value\": \"Versao1\"}" http://localhost:5001/set/mensagem
	@echo
	@echo "Valor gravado no node1. Use 'make example-3-get-value' para verificar a replicacao no node2."

## Verifica o valor no node2
example-3-get-value:
	$(UTF8_CONFIG)
	@echo "Verificando valor da chave 'mensagem' no node2..."
	@curl -s http://localhost:5002/get/mensagem
	@echo
	@echo "Se o valor for o mesmo que foi gravado no node1, a replicacao foi bem-sucedida."
	@echo "Caso contrario, aguarde alguns instantes para a consistencia eventual ou verifique se o node2 esta ativo."

## Para o container node2 para simular falha
example-3-kill-node2:
	$(UTF8_CONFIG)
	@echo "Parando o container node2 para simular falha no servidor..."
	@docker-compose -f $(EXAMPLE_3_DIR)/docker-compose.yml stop node2
	@echo "Container node2 parado com sucesso."
	@echo "Tente gravar novos valores no node1 com 'make example-3-set-value'."
	@echo "Depois reinicie o node2 com 'make example-3-start-node2' para ver a replicacao dos dados."

## Reinicia o container node2 após ter sido parado
example-3-start-node2:
	$(UTF8_CONFIG)
	@echo "Reiniciando o container node2..."
	@docker-compose -f $(EXAMPLE_3_DIR)/docker-compose.yml start node2
	@echo "Container node2 reiniciado com sucesso."
	@echo "Aguarde alguns instantes para que o node2 sincronize com o node1."
	@echo "Use 'make example-3-get-value' para verificar se os dados foram sincronizados."
