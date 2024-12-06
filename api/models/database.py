from flask_sqlalchemy import SQLAlchemy
import os

db = SQLAlchemy()

def init_db(app):
    server = os.getenv('DB_SERVER')  
    database = os.getenv('DB_NAME')  
    username = os.getenv('DB_USERNAME') 
    password = os.getenv('DB_PASSWORD')  
    driver = 'ODBC+Driver+17+for+SQL+Server'

    # Constructing the Azure SQL Database URI
    app.config['SQLALCHEMY_DATABASE_URI'] = f'mssql://{username}:{password}@{server}/{database}?driver={driver}'
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False  
    db.init_app(app)
