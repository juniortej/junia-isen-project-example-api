from .database import db

class Order(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, nullable=False)
    status = db.Column(db.String(20), default="Pending")
    items = db.Column(db.Text)  # JSON string of item IDs and quantities

    def save(self):
        db.session.add(self)
        db.session.commit()

    def to_dict(self):
        return {"id": self.id, "user_id": self.user_id, "status": self.status, "items": self.items}
