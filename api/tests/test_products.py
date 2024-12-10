import pytest
from app import app
from models.database import db
from models.products import Product

@pytest.fixture
def client():
    app.config['TESTING'] = True
    app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///:memory:'
    with app.test_client() as client:
        with app.app_context():
            db.create_all()
        yield client

def test_get_products(client):
    product = Product(name="Test Product", price=10.0, stock=100, category="Test Category")
    product.save()
    response = client.get('/products')
    assert response.status_code == 200
    assert len(response.json) == 1

def test_filter_products_by_name(client):
    product = Product(name="Test Product", price=10.0, stock=100, category="Test Category")
    product.save()
    response = client.get('/products', query_string={'name': 'Test'})
    assert response.status_code == 200
    assert len(response.json) == 1

def test_filter_products_by_category(client):
    product = Product(name="Test Product", price=10.0, stock=100, category="Test Category")
    product.save()
    response = client.get('/products', query_string={'category': 'Test Category'})
    assert response.status_code == 200
    assert len(response.json) == 1