from .database import db

class Basket(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, nullable=False)
    items = db.Column(db.String(255),nullable=False)  
    quantity= db.Column(db.Integer, nullable=False,default=0)
