import pytest
from app import app
from models.database import db
from models.products import Product
from models.orders import Order

@pytest.fixture
def client():
    app.config['TESTING'] = True
    app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///:memory:'
    with app.test_client() as client:
        with app.app_context():
            db.create_all()
        yield client

def test_add_product(client):
    response = client.post('/admin/products', json={'name': 'New Product', 'price': 20.0, 'stock': 50})
    assert response.status_code == 201
    assert response.json['message'] == 'Product added successfully'

def test_get_all_orders(client):
    order = Order(user_id=1, items='{"1": 2}')
    order.save()
    response = client.get('/admin/orders')
    assert response.status_code == 200
    assert len(response.json) == 1