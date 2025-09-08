.PHONY: help example-1 example-1-down example-1-logs example-1-status example-1-rebuild example-1-test example-1-kill-app-a example-1-start-app-a

# Diretório do exemplo 1
EXAMPLE_1_DIR = examples/1-load-balance-with-containers-simulating-failures

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
