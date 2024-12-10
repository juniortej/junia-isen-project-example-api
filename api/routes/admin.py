from flask import Blueprint, request, jsonify
from models.products import Product
from models.order import Order

admin_bp = Blueprint('admin', __name__)

@admin_bp.route('/admin/products', methods=['POST'])
def add_product():
    data = request.json
    product = Product(name=data['name'], price=data['price'], stock=data['stock'])
    product.save()
    return jsonify({"message": "Product added successfully"}), 201

@admin_bp.route('/admin/orders', methods=['GET'])
def get_all_orders():
    orders = Order.query.all()
    return jsonify([order.to_dict() for order in orders]), 200
