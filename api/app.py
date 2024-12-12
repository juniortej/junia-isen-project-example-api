from flask import Flask, jsonify

import os
import json
import psycopg2

from azure.identity import DefaultAzureCredential
from azure.storage.blob import BlobServiceClient

app = Flask(__name__)

def get_env_variable(key, default=None):
    # Fetches the value of an environment variable.
    try:
        return os.environ.get(key, default)
    except KeyError:
        raise Exception(f"Environment variable {key} not set")
    
# Database connection configuration
DB_CONFIG = {
    "dbname": get_env_variable("DATABASE_NAME"),
    "user": get_env_variable("DATABASE_USERNAME"),
    "password": get_env_variable("DATABASE_PASSWORD"),
    "host": get_env_variable("DATABASE_HOST"),  
    "port": get_env_variable("DATABASE_PORT", "5432")
}

def get_db_connection():
    # Establishes a connection to the PostgreSQL database.
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        return conn
    except Exception as e:
        raise Exception(f"Database connection failed: {e}")
    
def init_db():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        # SQL script for schema creation and data insertion
        sql_script = """
        -- Création de la base de données
        CREATE TABLE IF NOT EXISTS Users (
            id_user SERIAL PRIMARY KEY,
            firstname VARCHAR(100) NOT NULL,
            lastname VARCHAR(100) NOT NULL
        );

        CREATE TABLE IF NOT EXISTS Baskets (
            id_basket SERIAL PRIMARY KEY,
            user_id INT NOT NULL REFERENCES Users(id_user) ON DELETE CASCADE,
            items TEXT NOT NULL
        );

        -- Insertion de données
        INSERT INTO Users (firstname, lastname) VALUES 
        ('John', 'Doe'),
        ('Jane', 'Doe'),
        ('Alice', 'Smith'),
        ('Bob', 'Smith')
        ON CONFLICT DO NOTHING;

        INSERT INTO Baskets (user_id, items) VALUES 
        (1, '1,2,3'),
        (2, '4,5,6'),
        (3, '1,3,5'),
        (4, '2,4,6')
        ON CONFLICT DO NOTHING;
        """
        
        # Execute the SQL script
        cursor.execute(sql_script)
        
        # Commit the changes
        conn.commit()
        
        # Close the connection
        cursor.close()
        conn.close()
        
        print("Database initialized successfully.")
        
    except Exception as e:
        raise Exception(f"Database initialization failed: {e}")


@app.route("/")
def home():
    try:
        # Check if the database is already initialized
        conn = get_db_connection()
        cursor = conn.cursor()

        # Query to check if the "Users" table exists and contains data
        cursor.execute("SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'users');")
        table_exists = cursor.fetchone()[0]

        if not table_exists:
            # Initialize the database if the "Users" table does not exist
            init_db()
        else:
            # Check if there are users in the table
            cursor.execute("SELECT COUNT(*) FROM Users;")
            user_count = cursor.fetchone()[0]
            if user_count == 0:
                init_db()

        # Close the connection
        cursor.close()
        conn.close()
        
        return jsonify({"message": "Welcome to the Shop API!"})
    except Exception as e:
        return jsonify({"error": str(e)}), 500



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
        account_url = get_env_variable("STORAGE_BLOB_URL")
        default_credential = DefaultAzureCredential()
        blob_service_client = BlobServiceClient(account_url, credential=default_credential)
        
        container_client = blob_service_client.get_container_client(container="api")
        items_data = json.loads(container_client.download_blob("items.json").readall())
            
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
