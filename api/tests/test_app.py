import pytest
from api.app import app

@pytest.fixture
def client():
    app.testing = True
    with app.test_client() as client:
        yield client

def test_home(client):
    response = client.get("/")
    assert response.status_code == 200
    assert response.json == {"message": "Welcome to the Shop API!"}
    
def test_items(client):
    response = client.get("/items")
    assert response.status_code == 200
    
def test_baskets(client):
    response = client.get("/baskets")
    assert response.status_code == 200
    
def test_users(client):
    response = client.get("/users")
    assert response.status_code == 200
