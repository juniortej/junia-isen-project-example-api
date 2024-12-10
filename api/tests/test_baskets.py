import pytest
from app import app
from models.database import db
from models.products import Product
from models.baskets import Basket

@pytest.fixture
def client():
    app.config['TESTING'] = True
    app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///:memory:'
    with app.test_client() as client:
        with app.app_context():
            db.create_all()
        yield client

def test_add_to_basket(client):
    product = Product(name="Test Product", price=10.0, stock=100, category="Test Category")
    product.save()
    response = client.post('/basket/add', json={'user_id': 1, 'product_id': product.id, 'quantity': 1})
    assert response.status_code == 201
    assert response.json['message'] == 'Item added to basket'

def test_add_multiple_items_to_basket(client):
    product1 = Product(name="Test Product 1", price=10.0, stock=100, category="Test Category")
    product2 = Product(name="Test Product 2", price=20.0, stock=50, category="Test Category")
    product1.save()
    product2.save()
    client.post('/basket/add', json={'user_id': 1, 'product_id': product1.id, 'quantity': 1})
    response = client.post('/basket.add', json={'user_id': 1, 'product_id': product2.id, 'quantity': 2})
    assert response.status_code == 201
    assert response.json['message'] == 'Item added to basket'