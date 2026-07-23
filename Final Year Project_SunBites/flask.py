import pandas as pd
import joblib
from flask import Flask, request, jsonify

# ==========================================
# Initialize Flask App
# ==========================================
app = Flask(__name__)

# ==========================================
# Load Models
# ==========================================
sentiment_model = joblib.load("backend/sentiment_model.joblib")
fake_model = joblib.load("backend/fake_review_model.joblib")

# ==========================================
# Load Restaurant Dataset
# ==========================================
restaurant_data = pd.read_csv("backend/restaurant_summary.csv")  

# ==========================================
# Recommendation Function
# ==========================================
def recommend_restaurants(
        restaurant_data,
        category,
        location,
        min_star,
        dietary,
        budget,
        top_k=5):

    # Clean user inputs to avoid mismatch due to spaces or case differences
    category = category.strip().lower()
    location = location.strip().lower()
    dietary = dietary.strip().lower()
    budget = budget.strip().lower()

    # Store which filters were relaxed during recommendation
    relaxed_steps = []

    # Step 1: Apply strict filtering based on all user preferences
    results = restaurant_data[
        (restaurant_data["category"].str.lower() == category) &
        (restaurant_data["location"].str.lower() == location) &
        (restaurant_data["avg_star"] >= min_star) &
        (restaurant_data["dietary_preference"].str.lower() == dietary) &
        (restaurant_data["price_range"].str.lower() == budget)
    ]

    # Step 2: Relax dietary preference if no restaurant matches
    if results.empty:

        relaxed_steps.append("Dietary preference relaxed")

        results = restaurant_data[
            (restaurant_data["category"].str.lower() == category) &
            (restaurant_data["location"].str.lower() == location) &
            (restaurant_data["avg_star"] >= min_star) &
            (restaurant_data["price_range"].str.lower() == budget)
        ]

    # Step 3: Relax budget constraint if still no results
    if results.empty:

        relaxed_steps.append("Budget constraint relaxed")

        results = restaurant_data[
            (restaurant_data["category"].str.lower() == category) &
            (restaurant_data["location"].str.lower() == location) &
            (restaurant_data["avg_star"] >= min_star)
        ]

    # Step 4: Relax location requirement if still empty
    if results.empty:

        relaxed_steps.append("Location filter relaxed")

        results = restaurant_data[
            (restaurant_data["category"].str.lower() == category) &
            (restaurant_data["avg_star"] >= min_star)
        ]

    # Step 5: Lower minimum star rating requirement
    if results.empty:
        relaxed_steps.append("Minimum star rating lowered")

        results = restaurant_data[
            (restaurant_data["category"].str.lower() == category) &
            (restaurant_data["avg_star"] >= (min_star - 1))
        ]

    # Optional final fallback: return all restaurants in same category
    if results.empty:
        relaxed_steps.append("Returning top restaurants from same category")

        results = restaurant_data[
            restaurant_data["category"].str.lower() == category
        ]

    # Rank restaurants using the computed recommendation score
    results = results.sort_values(by="score", ascending=False)

    # Return top K recommended restaurants
    return results.head(top_k), relaxed_steps


# ==========================================
# API: Sentiment Prediction
# ==========================================

@app.route("/predict_sentiment", methods=["POST"])
def predict_sentiment():

    data = request.get_json()

    review_text = data["review"]

    prediction = sentiment_model.predict([review_text])[0]

    return jsonify({
        "review": review_text,
        "predicted_sentiment": prediction
    })


# ==========================================
# API: Fake Review Detection
# ==========================================

@app.route("/detect_fake_review", methods=["POST"])
def detect_fake_review():

    data = request.get_json()

    features = [
        data["review_length"],
        data["author_reviews"],
        data["local_guide"],
        data["rating_scaled"],
        data["sentiment_score"],
        data["days_since_review"],
        data["extreme_rating"],
        data["reviewer_trust"],
        data["exclamation_count"],
        data["question_count"],
        data["uppercase_ratio"],
    ]

    prediction = fake_model.predict([features])[0]

    probability = fake_model.predict_proba([features])[0][1]

    return jsonify({
        "fake_prediction": int(prediction),
        "fake_probability": float(probability)
    })


# ==========================================
# API: Restaurant Recommendation
# ==========================================

@app.route("/recommend", methods=["POST"])
def recommend():

    data = request.get_json()

    category = data["category"]
    location = data["location"]
    min_star = float(data["min_star"])
    top_k = data.get("top_k", 5)

    results, relaxed = recommend_restaurants(
        restaurant_data,
        category,
        location,
        min_star,
        data["dietary"],
        data["budget"],
        top_k
        )

    recommendations = results.to_dict(orient="records")

    return jsonify({
        "recommendations": recommendations,
        "relaxed_filters": relaxed
    })


# ==========================================
# Root Endpoint
# ==========================================

@app.route("/")
def home():
    return """
    <h1>Restaurant API Tester</h1>
    <form action="/recommend" method="post" enctype="application/json">
        <p>This is a JSON API. To test it easily, use a tool like Postman 
        or the PowerShell scripts provided earlier.</p>
        <a href="https://www.postman.com/downloads/">Download Postman here</a>
    </form>
    """

    return jsonify({
        "message": "Restaurant Recommendation API is running"
    })

# ==========================================
# Run Flask Server
# ==========================================

if __name__ == "__main__":
    app.run(debug=True)