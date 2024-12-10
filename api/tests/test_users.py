def test_update_profile(client):
    # Assuming the user is logged in and their ID is 1
    response = client.put('/profile', json={'user_id': 1, 'username': 'new_username', 'password': 'new_password'})
    assert response.status_code == 200
    assert response.json["message"] == "Profile updated successfully"
