from flask import Blueprint, request, jsonify
from models.baskets import Basket
from models.products import Product

basket_bp = Blueprint('basket', __name__)

@basket_bp.route('/basket/add', methods=['POST'])
def add_to_basket():
    data = request.form
    product = Product.query.get(data['product_id'])
    if not product or product.stock < int(data['quantity']):
        return jsonify({"error": "Product not found or out of stock"}), 404

    basket = Basket.query.filter_by(user_id=data['user_id']).filter_by(product_id=data['product_id'])
    if not basket:
        basket = Basket(user_id=data['user_id'], items=data['product_id'],quantity=data['quantity'])
    else:
        basket.quantity=basket.quantity+int(data['quantity'])    
    basket.save()
    return jsonify({"message":f"{data.quantity} {product.name} added to basket"}), 201
@basket_bp.route('/basket/delete', methods=['POST'])

def remove_from_basket():
    data = request.form
    product=Product.query.get(data['product_id'])
    basket = Basket.query.filter_by(user_id=data['user_id']).filter_by(product_id=data['product_id']).first()
    
    if basket:
        db.session.delete(basket)
        db.session.commit()
        return jsonify({"message":f"{product.name} removed from basket"}), 201
    else:
        return jsonify({"error": "Basket item not found"}), 404