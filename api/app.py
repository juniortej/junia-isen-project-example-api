from flask import Flask, jsonify

import os
import json
import psycopg2

from azure.identity import DefaultAzureCredential
from azure.storage.blob import BlobServiceClient

app = Flask(__name__)

# Database connection configuration
DB_CONFIG = {
    "dbname": "cloud-api-project",
    "user": "postgres",
    "password": "postgres",
    "host": "localhost",  # Adjust if running elsewhere
    "port": 5432
}

def get_db_connection():
    # Establishes a connection to the PostgreSQL database.
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        return conn
    except Exception as e:
        raise Exception(f"Database connection failed: {e}")

def get_env_variable(key, default=None):
    # Fetches the value of an environment variable.
    try:
        return os.environ.get(key, default)
    except KeyError:
        raise Exception(f"Environment variable {key} not set")

@app.route("/")
def home():
    return jsonify({"message": "Welcome to the Shop API!"})

"""
@app.route("/items")
def items():
    try:
        # Définir le chemin vers le fichier JSON
        json_file_path = os.path.join(os.path.dirname(__file__), "../resources/blob_storage/items.json")
        
        # Lire le contenu du fichier JSON
        with open(json_file_path, "r") as json_file:
            items_data = json.load(json_file)
        
        # Retourner les données JSON comme réponse
        return app.response_class(
            response=json.dumps(items_data, indent=4),
            mimetype='application/json'
        )
    except FileNotFoundError:
        return jsonify({"error": "File not found"}), 404
    except json.JSONDecodeError:
        return jsonify({"error": "Invalid JSON format"}), 500
    except Exception as e:
        return jsonify({"error": str(e)}), 500

"""
@app.route("/items")
def items():
    try:
        account_url = get_env_variable("STORAGE_BLOB_URL")
        default_credential = DefaultAzureCredential()
        blob_service_client = BlobServiceClient(account_url, credential=default_credential)
        
        container_client = blob_service_client.get_container_client(container="api")
        items = json.loads(container_client.download_blob("items.json").readall())
        
        return app.response_class(
            response=json.dumps(items, indent=4),
            mimetype='application/json'
        )
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/baskets")
def baskets():
    try:
        # Connect to the database
        conn = get_db_connection()
        cursor = conn.cursor()
        
        # Query to fetch all baskets
        query = "SELECT id_basket, user_id, items FROM Baskets;"
        cursor.execute(query)
        baskets = cursor.fetchall()
        
        # Format the result as JSON and fetch items data
        items_file_path = os.path.join(os.path.dirname(__file__), "../resources/blob_storage/items.json")
        with open(items_file_path, "r") as items_file:
            items_data = json.load(items_file)
            
        baskets_data = []
        for basket in baskets:
            basket_id = basket[0]
            user_id = basket[1]
            item_ids = basket[2]
            item_ids = item_ids.split(",")
            items = [item for item in items_data if str(item["id_item"]) in item_ids]
            # Get the user information
            query = f"SELECT * FROM Users WHERE id_user = {user_id};"
            cursor.execute(query)
            user_info = cursor.fetchone()            
            baskets_data.append({"id_basket": basket_id, "user": {"id_user": user_info[0], "firstname": user_info[1], "lastname": user_info[2]}, "items": items})              
        
        # Close the connection
        cursor.close()
        conn.close()
        
        return app.response_class(
            response=json.dumps(baskets_data, indent=4),
            mimetype='application/json'
        )
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route("/users")
def users():
    try:
        # Connect to the database
        conn = get_db_connection()
        cursor = conn.cursor()
        
        # Query to fetch all users
        query = "SELECT id_user, firstname, lastname FROM Users;"
        cursor.execute(query)
        users = cursor.fetchall()
        
        # Format the result as JSON
        users_data = [{"id_user": user[0], "firstname": user[1], "lastname": user[2]} for user in users]
        
        # Close the connection
        cursor.close()
        conn.close()
        
        return app.response_class(
            response=json.dumps(users_data, indent=4),
            mimetype='application/json'
        )
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
