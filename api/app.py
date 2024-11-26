from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/")
def home():
    return jsonify({"message": "Welcome to the Shop API!"})

@app.route("/items")
def items():
    return jsonify({"message": "List of items"})

@app.route("/baskets")
def baskets():
    return jsonify({"message": "List of baskets"})

@app.route("/users")
def users():
    return jsonify({"message": "List of users"})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
