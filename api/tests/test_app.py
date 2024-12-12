import pytest
from api.app import app

@pytest.fixture
def client():
    # Configures the app for testing
    app.testing = True
    with app.test_client() as client:
        yield client

def test_home(client):
    response = client.get("/")
    assert response.status_code == 200
    assert response.json == {"message": "Welcome to the Shop API!"}

def test_items(client, mocker):
    # Mock the items.json blob download
    mocker.patch(
        "api.app.BlobServiceClient.get_container_client",
        return_value=mocker.Mock(
            download_blob=mocker.Mock(
                return_value=mocker.Mock(
                    readall=lambda: b'[{"id_item": 1, "name": "Item 1"}]'
                )
            )
        ),
    )
    response = client.get("/items")
    assert response.status_code == 200
    assert "Item 1" in response.json[0]["name"]

def test_baskets(client, mocker):
    # Mock database and blob storage for baskets
    mocker.patch(
        "api.app.BlobServiceClient.get_container_client",
        return_value=mocker.Mock(
            download_blob=mocker.Mock(
                return_value=mocker.Mock(
                    readall=lambda: b'[{"id_item": 1, "name": "Item 1"}]'
                )
            )
        ),
    )
    response = client.get("/baskets")
    assert response.status_code == 200
    # Add assertions for expected basket structure

def test_users(client):
    response = client.get("/users")
    assert response.status_code == 200
    assert isinstance(response.json, list)
    assert "id_user" in response.json[0]
