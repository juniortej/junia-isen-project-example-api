from flask_sqlalchemy import SQLAlchemy
import os

db = SQLAlchemy()

def init_db(app):
    # Replace with your Azure SQL Database connection details
    server = os.getenv('DB_SERVER')  # Azure SQL Server name
    database = os.getenv('DB_NAME')  # Azure SQL Database name
    username = os.getenv('DB_USERNAME')  # Database username
    password = os.getenv('DB_PASSWORD')  # Database password
    driver = 'ODBC+Driver+17+for+SQL+Server'

    # Constructing the Azure SQL Database URI
    app.config['SQLALCHEMY_DATABASE_URI'] = f'mssql://{username}:{password}@{server}/{database}?driver={driver}'
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False  # Disable modification tracking for performance

    db.init_app(app)
