from flask import Flask, jsonify, request, abort, render_template
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address
from azure.cosmos import CosmosClient, exceptions
from dotenv import load_dotenv
from flask_cors import CORS
import os

# Charger les variables d'environnement
load_dotenv()

# Configuration des données Cosmos DB
COSMOS_ENDPOINT = os.getenv("COSMOSDB_ENDPOINT")
COSMOS_KEY = os.getenv("COSMOSDB_READONLY_KEY")
DATABASE_NAME = os.getenv("COSMOSDB_DATABASE_NAME")

# Conteneurs
ITEMS_COLLECTION = "Items"
BASKETS_COLLECTION = "Baskets"
USERS_COLLECTION = "Users"

# Configuration de Flask
app = Flask(__name__)
CORS(app)

# Configuration des limiteurs
limiter = Limiter(
    get_remote_address,
    app=app,
    default_limits=["20 per minute"],
    storage_uri="memory://",
)

# Initialisation du client Cosmos DB
cosmos_client = CosmosClient(COSMOS_ENDPOINT, COSMOS_KEY)
db_client = cosmos_client.get_database_client(DATABASE_NAME)
items_container = db_client.get_container_client(ITEMS_COLLECTION)
baskets_container = db_client.get_container_client(BASKETS_COLLECTION)
users_container = db_client.get_container_client(USERS_COLLECTION)

# Clé d'authentification API
SECRET_API_KEY = "top_secret_key"


def authenticate_request():
    """Valide la clé API présente dans l'en-tête des requêtes."""
    if request.headers.get("x-api-key") != SECRET_API_KEY:
        abort(401, "Clé API non valide")


@app.route("/")
def welcome():
    """Page d'accueil avec un message de bienvenue."""
    return jsonify({"message": "Bienvenue sur l'API Shop App !"})

# Endpoint pour récupérer les utilisateurs
@app.route("/users", methods=["GET"])
@limiter.limit("15 per minute")
def fetch_users():
    authenticate_request()
    try:
        users = list(users_container.read_all_items())
        return jsonify({"users": users}), 200
    except exceptions.CosmosHttpResponseError as error:
        return jsonify({"error": str(error)}), 500


# Endpoint pour récupérer les paniers
@app.route("/baskets", methods=["GET"])
@limiter.limit("5 per minute")
def fetch_baskets():
    authenticate_request()
    try:
        baskets = list(baskets_container.read_all_items())
        return jsonify({"baskets": baskets}), 200
    except exceptions.CosmosHttpResponseError as error:
        return jsonify({"error": str(error)}), 500


# Endpoint pour ajouter un nouvel item
@app.route("/items", methods=["POST"])
@limiter.exempt  # Pas de limite sur les requêtes POST pour cet endpoint
def add_new_item():
    authenticate_request()
    payload = request.json
    if not payload or "id" not in payload or "name" not in payload:
        abort(400, "Les données envoyées sont incomplètes ou invalides.")

    item_data = {
        "id": payload["id"],
        "name": payload["name"],
        "partitionKey": payload["id"]
    }

    try:
        items_container.create_item(item_data)
        return jsonify({"message": "Nouvel item ajouté avec succès.", "item": item_data}), 201
    except exceptions.CosmosResourceExistsError:
        return jsonify({"error": "Cet item existe déjà."}), 409


# Endpoint pour récupérer tous les items
@app.route("/items", methods=["GET"])
@limiter.limit("20 per minute")
def fetch_items():
    authenticate_request()
    try:
        items = list(items_container.read_all_items())
        return jsonify({"items": items}), 200
    except exceptions.CosmosHttpResponseError as error:
        return jsonify({"error": str(error)}), 500

# Gestion des erreurs globales
@app.errorhandler(401)
def handle_unauthorized(error):
    return jsonify({"error": "Non autorisé. Vérifiez votre clé API."}), 401


@app.errorhandler(400)
def handle_bad_request(error):
    return jsonify({"error": "Requête invalide : " + str(error)}), 400


@app.errorhandler(500)
def handle_internal_error(error):
    return jsonify({"error": "Erreur interne du serveur : " + str(error)}), 500


# Point d'entrée de l'application
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080, debug=True)
