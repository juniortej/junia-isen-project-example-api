from flask import Blueprint, request, jsonify, render_template
from models.users import User
from werkzeug.security import generate_password_hash, check_password_hash

profile_bp = Blueprint('profile', __name__)

@profile_bp.route('/profile', methods=['GET', 'POST'])
def profile():
    if request.method == 'POST':
        data = request.form
        user_id = data.get('user_id')
        username = data.get('username')
        password = data.get('password')

        user = User.query.get(user_id)
        if not user:
            return jsonify({"error": "User not found"}), 404

        if username:
            user.username = username
        if password:
            user.password = generate_password_hash(password, method='sha256')

        user.save()
        return jsonify({"message": "Profile updated successfully"}), 200

    user_id = request.args.get('user_id')
    user = User.query.get(user_id)
    return render_template('profile.html', user=user)