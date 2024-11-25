from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/")
def home():
    return jsonify({"message": "Je souhaite me donner la mort dans les plus bref delais"})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
