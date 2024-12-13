from flask import Blueprint, request, jsonify, redirect, url_for, render_template
from models.users import User
from werkzeug.security import generate_password_hash, check_password_hash

auth_bp = Blueprint('auth', __name__)

@auth_bp.route('/auth/register', methods=['POST'])
def register():
    if request.method == 'POST':
        data = request.form
        hashed_password = generate_password_hash(data['password'], method='sha256')

        user = User(username=data['username'], password=hashed_password, role="customer")
        user.save()

        return redirect(url_for('home'))
    return render_template('register.html')

@auth_bp.route('/auth/login', methods=['POST'])
def login():
    if request.method == 'POST':
        data = request.form
        user = User.query.filter_by(username=data['username']).first()

        if user and check_password_hash(user.password, data['password']):
            if user.role == "admin":
                return redirect(url_for('admin'))
            return redirect(url_for('home'))
        return jsonify({"error": "Invalid credentials"}), 401
    return render_template('login.html')