import pytest
from app import app
from models.database import db

@pytest.fixture
def client():
    app.config['TESTING'] = True
    app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///:memory:'
    with app.test_client() as client:
        with app.app_context():
            db.create_all()
        yield client

def test_get_products(client):
    response = client.get('/products')
    assert response.status_code == 200
    assert response.json == []