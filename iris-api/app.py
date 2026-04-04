from flask import Flask, request, jsonify
import joblib
import numpy as np
from flask_cors import CORS

model = joblib.load("iris_model.pkl")

app = Flask(__name__)
CORS(app)

@app.route("/predict", methods=["POST"])
def predict():
    try:
        data = request.get_json()
        features = np.array(data["features"]).reshape(1, -1)
        prediction = model.predict(features)
        return jsonify({"prediction": int(prediction[0])})
    except Exception as e:
        return jsonify({"error" : str(e)})

if __name__ == "__main__":
    app.run(debug=True)