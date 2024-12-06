from flask import Flask
from routes.home import home_bp
from routes.items import items_bp
from routes.baskets import baskets_bp
from routes.users import users_bp
from models.database import init_db

app = Flask(__name__)
init_db(app)

# Register blueprints
app.register_blueprint(home_bp)
app.register_blueprint(items_bp, url_prefix='/items')
app.register_blueprint(baskets_bp, url_prefix='/baskets')
app.register_blueprint(users_bp, url_prefix='/users')

if __name__ == "__main__":
    app.run(debug=True)
