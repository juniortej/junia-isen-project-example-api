from flask import Blueprint, request, jsonify
from models.products import Product
from models.orders import Order

admin_bp = Blueprint('admin', __name__)

@admin_bp.route('/admin/products', methods=['POST'])
def add_product():
    data = request.json
    product = Product(name=data['name'], price=data['price'], stock=data['stock'], category=data['category'])
    product.save()
    return jsonify({"message": "Product added successfully"}), 201

@admin_bp.route('/admin/orders', methods=['GET'])
def get_all_orders():
    user_id = request.args.get('user_id')
    if user_id:
        orders = Order.query.filter_by(user_id=user_id).all()
    else:
        orders = Order.query.all()
    return jsonify([order.to_dict() for order in orders]), 200