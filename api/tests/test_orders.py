import pytest
from app import app
from models.database import db
from models.user import User
from models.basket import Basket
from models.order import Order

@pytest.fixture
def client():
    app.config['TESTING'] = True
    app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///:memory:'
    with app.test_client() as client:
        with app.app_context():
            db.create_all()
        yield client

def test_view_orders(client):
    user = User(username='testuser', password='testpass')
    user.save()
    order = Order(user_id=user.id, items='{"1": 2}')
    order.save()
    response = client.get('/orders', query_string={'user_id': user.id})
    assert response.status_code == 200
    assert len(response.json) == 1

def test_place_order(client):
    user = User(username='testuser', password='testpass')
    user.save()
    basket = Basket(user_id=user.id, items='{"1": 2}')
    basket.save()
    response = client.post('/orders', json={'user_id': user.id})
    assert response.status_code == 201
    assert response.json['message'] == 'Order placed successfully'