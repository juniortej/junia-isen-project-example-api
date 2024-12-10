from flask import Blueprint, request, jsonify
from models.users import User
from werkzeug.security import generate_password_hash, check_password_hash

profile_bp = Blueprint('profile', __name__)

# Get profile information
@profile_bp.route('/profile', methods=['GET'])
def get_profile():
    user_id = request.args.get('user_id')  
    user = User.query.get(user_id)
    if user:
        return jsonify({"username": user.username, "role": user.role}), 200
    return jsonify({"error": "User not found"}), 404

# Update profile information
@profile_bp.route('/profile', methods=['PUT'])
def update_profile():
    data = request.json
    user_id = data.get('user_id')
    username = data.get('username')
    password = data.get('password')

    # Find user by user_id
    user = User.query.get(user_id)
    if not user:
        return jsonify({"error": "User not found"}), 404

    # Update username and password (if provided)
    if username:
        user.username = username
    if password:
        user.password = generate_password_hash(password, method='sha256')

    user.save()  # Save changes to the database

    return jsonify({"message": "Profile updated successfully"}), 200
