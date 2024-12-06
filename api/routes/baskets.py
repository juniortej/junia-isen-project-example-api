from flask import Blueprint

baskets_bp = Blueprint('baskets', __name__)

@baskets_bp.route('/')
def get_baskets():
    return {"baskets": []}, 200  
