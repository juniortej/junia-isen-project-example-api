from flask import Blueprint, request, jsonify
from models.baskets import Basket
from models.products import Product

basket_bp = Blueprint('basket', __name__)

@basket_bp.route('/basket/add', methods=['POST'])
def add_to_basket():
    data = request.form
    product = Product.query.get(data['product_id'])
    if not product:
        return jsonify({"error": "Product not found"}), 404

    basket = Basket.query.filter_by(user_id=data['user_id']).first()
    if not basket:
        basket = Basket(user_id=data['user_id'], items=f"{data['product_id']}:{data['quantity']}")
    else:
        items = dict(item.split(':') for item in basket.items.split(','))
        items[data['product_id']] = str(int(items.get(data['product_id'], 0)) + int(data['quantity']))
        basket.items = ','.join(f"{k}:{v}" for k, v in items.items())
    
    basket.save()
    return jsonify({"message": "Item added to basket"}), 201