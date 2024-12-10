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

def test_get_profile(client):
    user = User(username='testuser', password='testpass')
    user.save()
    response = client.get('/profile', query_string={'user_id': user.id})
    assert response.status_code == 200
    assert response.json['username'] == 'testuser'

def test_update_profile(client):
    user = User(username='testuser', password='testpass')
    user.save()
    response = client.put('/profile', json={'user_id': user.id, 'username': 'updateduser', 'password': 'newpass'})
    assert response.status_code == 200
    assert response.json['message'] == 'Profile updated successfully'