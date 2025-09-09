from flask import Flask, request, jsonify
import requests
import os
import time

app = Flask(__name__)

# Identificador do nó (ex.: node1 ou node2)
NODE_NAME = os.environ.get("NODE_NAME", "unknown")
PEER = os.environ.get("PEER")  # endereço do outro nó

data_store = {}

@app.route("/set/<key>", methods=["POST"])
def set_value(key):
    value = request.json.get("value")
    data_store[key] = value

    # Replica para o peer se existir
    if PEER:
        try:
            requests.post(f"http://{PEER}/replicate/{key}", json={"value": value}, timeout=1)
        except Exception as e:
            print(f"Falha ao replicar para {PEER}: {e}")

    return jsonify({key: value, "node": NODE_NAME})

@app.route("/replicate/<key>", methods=["POST"])
def replicate_value(key):
    # Simula atraso de rede/processamento (ex.: 10 segundos)
    time.sleep(10)

    value = request.json.get("value")
    data_store[key] = value
    return jsonify({"status": "replicated", "node": NODE_NAME})

@app.route("/get/<key>", methods=["GET"])
def get_value(key):
    return jsonify({key: data_store.get(key), "node": NODE_NAME})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
