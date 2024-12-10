from .database import db

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), nullable=False, unique=True)
    password = db.Column(db.String(200), nullable=False)
    role = db.Column(db.String(20), default="customer")

    def save(self):
        db.session.add(self)
        db.session.commit()

    def to_dict(self):
        return {"id": self.id, "username": self.username, "role": self.role}
