from flask import Blueprint, request, jsonify
from models.orders import Order
from models.products import Product
from models.baskets import Basket
from models.database import db

orders_bp = Blueprint('orders', __name__)

# View orders for a customer
@orders_bp.route('/orders', methods=['GET'])
def view_orders():
    user_id = request.args.get('user_id')  # Or use JWT for authentication

    orders = Order.query.filter_by(user_id=user_id).all()
    if not orders:
        return jsonify({"message": "No orders found"}), 404

    return jsonify([order.to_dict() for order in orders]), 200

# Place a new order (assuming it's from the user's basket)
@orders_bp.route('/orders', methods=['POST'])
def place_order():
    data = request.json
    user_id = data.get('user_id')
    
    # Assuming basket items are passed along with the order request
    basket_items = Basket.query.filter_by(user_id=user_id).first().items
    if not basket_items:
        return jsonify({"error": "Basket is empty"}), 400

    # Create a new order
    new_order = Order(user_id=user_id, items=basket_items)
    new_order.save()

    # Clear the basket after order placement
    Basket.query.filter_by(user_id=user_id).delete()
    db.session.commit()

    return jsonify({"message": "Order placed successfully", "order_id": new_order.id}), 201
