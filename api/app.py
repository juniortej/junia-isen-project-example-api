from flask import Flask, jsonify, request, abort

app = Flask(__name__)

limiter = Limiter(get_remote_address, app=app)

# Clé API à stocker dans une variable d'environnement ou fichier sécurisé
API_KEY = "super_secret_key"

def verify_api_key():
    key = request.headers.get("x-api-key")
    if key != API_KEY:
        abort(403)  # Refuser l'accès si la clé est invalide

@app.route("/")
def home():
    return jsonify({"message": "Lancelot je t'aime"})

@app.route("/items", methods=["GET"])
@limiter.limit("10 per minute")  # Limite à 10 requêtes par minute
def get_items():
    verify_api_key()
    return jsonify({"items": ["item1", "item2"]})


@app.route("/baskets", methods=["GET"])
def get_baskets():
    verify_api_key()
    return jsonify({"baskets": ["basket1", "basket2"]})

@app.route("/users", methods=["GET"])
def get_users():
    verify_api_key()
    return jsonify({"users": ["user1", "user2"]})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80, debug=False)
