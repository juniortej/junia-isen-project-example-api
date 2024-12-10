from flask import Blueprint, request, jsonify
from models.baskets import Basket
from models.products import Product

basket_bp = Blueprint('basket', __name__)

@basket_bp.route('/basket/add', methods=['POST'])
def add_to_basket():
    product_id = request.json['product_id']
    quantity = request.json.get('quantity', 1)
    product = Product.query.get(product_id)

    if not product:
        return jsonify({"error": "Product not found"}), 404

    basket = Basket.add_product(product_id, quantity)
    return jsonify({"message": "Product added to basket", "basket": basket.to_dict()}), 200
