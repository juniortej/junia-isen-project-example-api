import pytest
from app import app
from models.database import db
from models.users import User

@pytest.fixture
def client():
    app.config['TESTING'] = True
    app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///:memory:'
    with app.test_client() as client:
        with app.app_context():
            db.create_all()
        yield client

def test_register(client):
    response = client.post('/auth/register', json={'username': 'testuser', 'password': 'testpass'})
    assert response.status_code == 201
    assert response.json['message'] == 'User registered successfully'

def test_login(client):
    user = User(username='testuser', password='testpass')
    user.save()
    response = client.post('/auth/login', json={'username': 'testuser', 'password': 'testpass'})
    assert response.status_code == 200
    assert response.json['message'] == 'Login successful'