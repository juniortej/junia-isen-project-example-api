from flask import Flask, render_template
from routes.products import products_bp
from routes.baskets import basket_bp
from routes.auth import auth_bp
from routes.profile import profile_bp
from routes.orders import orders_bp
from routes.admin import admin_bp
from models.database import init_db

app = Flask(__name__)
init_db(app)

# Register blueprints
app.register_blueprint(products_bp)
app.register_blueprint(basket_bp)
app.register_blueprint(auth_bp)
app.register_blueprint(profile_bp)
app.register_blueprint(orders_bp)
app.register_blueprint(admin_bp)

@app.route('/')
def home():
    return render_template('home.html')

if __name__ == "__main__":
    app.run(debug=True)