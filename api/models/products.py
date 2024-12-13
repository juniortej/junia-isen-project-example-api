from .database import db

class Product(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    price = db.Column(db.Float, nullable=False)
    stock = db.Column(db.Integer, default=0)
    category = db.Column(db.String(50), nullable=False)  

    def to_dict(self):
        return {"id": self.id, "name": self.name, "price": self.price, "stock": self.stock, "category": self.category}