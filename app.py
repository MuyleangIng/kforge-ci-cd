from flask import Flask, jsonify

app = Flask(__name__)


@app.get("/")
def index():
    return jsonify(
        {
            "app": "flask-ci-demo",
            "service": "flask",
            "message": "Built with kforge CI bootstrap",
        }
    )


@app.get("/health")
def health():
    return jsonify({"status": "ok"})
