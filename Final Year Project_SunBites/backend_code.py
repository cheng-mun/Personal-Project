import os
import numpy as np
import pandas as pd
import joblib
from sklearn.model_selection import train_test_split
from sklearn.pipeline import Pipeline
from sklearn.metrics import classification_report, confusion_matrix, f1_score, accuracy_score
from sklearn.ensemble import RandomForestClassifier
from imblearn.over_sampling import RandomOverSampler
from imblearn.pipeline import Pipeline as ImbPipeline
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression

# ==========================================================================================
# SENTIMENT ANALYSIS
# ==========================================================================================

def run_sentiment_analysis(df):

    # Function to convert star ratings into sentiment labels
    # 1–2 stars → negative
    # 3 stars → neutral
    # 4–5 stars → positive
    def label_sentiment(star):
        if star <= 2: return "negative"
        elif star == 3: return "neutral"
        else: return "positive"

    # Apply the sentiment labeling rule to create the training target variable
    df["sentiment_label"] = df["star_rating"].astype(int).apply(label_sentiment)

    # Text feature (review content) used for model training
    X = df["cleaned_review_content"].astype(str)

    # Target variable (sentiment class)
    y = df["sentiment_label"].astype(str)

    # Split dataset into training and temporary sets (80% train, 20% remaining)
    X_train, X_temp, y_train, y_temp = train_test_split(
        X, y, test_size=0.20, stratify=y, random_state=42
    )

    # Split remaining data equally into validation and test sets (10% each)
    X_val, X_test, y_val, y_test = train_test_split(
        X_temp, y_temp, test_size=0.50, stratify=y_temp, random_state=42
    )

    # Build a machine learning pipeline:
    # Step 1: Convert text to numerical features using TF-IDF
    # Step 2: Train Logistic Regression classifier
    pipe = ImbPipeline([
        ("tfidf", TfidfVectorizer(
            max_features=20000,
            ngram_range=(1, 3),
            stop_words="english",
            min_df=2,
            max_df=0.95,
            sublinear_tf=True,
            lowercase=True
        )),
        ("oversample", RandomOverSampler(random_state=42)),
        ("clf", LogisticRegression(
            solver="saga",
            C=3.0,
            class_weight="balanced",
            random_state=42,
            max_iter=5000
        ))
    ])

    # Train the sentiment classification model
    pipe.fit(X_train, y_train)

    # Save model
    model_path = "/Users/meganchow/Desktop/models"
    os.makedirs(model_path, exist_ok=True)
    joblib.dump(pipe, f"{model_path}/sentiment_model.joblib")

    # Evaluate model performance on validation data
    print("Sentiment Analysis Results:")
    print(classification_report(y_val, pipe.predict(X_val)))
    print(confusion_matrix(y_test, pipe.predict(X_test)))

    # Evaluate model performance on unseen test data
    print("Test Accuracy:", accuracy_score(y_test, pipe.predict(X_test)))
    print("Test Macro F1:", f1_score(y_test, pipe.predict(X_test), average="macro"))

    # Predict sentiment class for all reviews in dataset
    df["predicted_sentiment"] = pipe.predict(df["cleaned_review_content"])
 
    # Convert predicted_sentiment labels into numeric scores
    sentiment_map = {
        "negative": -1,
        "neutral": 0,
        "positive": 1
    }
    df["sentiment_score"] = df["predicted_sentiment"].map(sentiment_map)

    # Normalize star ratings into the same scale (-1 to 1)
    # 1 star → -1
    # 3 stars → 0
    # 5 stars → 1
    df["rating_scaled"] = (df["star_rating"] - 3) / 2

    # Compute mismatch between review sentiment and star rating
    # Larger difference indicates potential inconsistency
    df["diff_sentiment"] = abs(df["sentiment_score"] - df["rating_scaled"])

    return df

# ==========================================================================================
# FAKE REVIEW DETECTION
# ==========================================================================================

def detect_fake_reviews(df):

    # Features Engineering:

    # Convert local guide status to binary value (1 = yes, 0 = no)
    df["local_guide"] = df["local_guide"].astype(str).str.lower().str.contains("yes|true|1").astype(int)

    # Convert author review count into numeric values
    df["author_reviews"] = pd.to_numeric(df["author_reviews"], errors="coerce").fillna(0).astype(int)

    # Recency
    # Convert review date to datetime format
    df["review_date"] = pd.to_datetime(df["review_date"], errors="coerce")
    # Use today's date as reference point
    ref = pd.Timestamp.today()

    # Compute how many days ago the review was written
    df["days_since_review"] = (ref - df["review_date"]).dt.days
    # Replace missing recency values with median days
    df["days_since_review"] = df["days_since_review"].fillna(df["days_since_review"].median()).astype(int)

    # Reviewer credibility
    # Local guides are given higher trust weight
    df["reviewer_trust"] = df["author_reviews"] + (df["local_guide"] * 10)

    # Review Extremeness 
    # Flag extreme ratings (1 star or 5 stars)
    df["extreme_rating"] = ((df["star_rating"] == 1) | (df["star_rating"] == 5)).astype(int)

    # Review length
    # Calculate review length (number of words)
    df["review_length"] = df["raw_review_content"].fillna("").str.split().apply(len)

    # Exclamation marks
    # Count number of exclamation marks (possible exaggeration indicator)
    df["exclamation_count"] = df["raw_review_content"].str.count("!")

    # Question marks
    # Count number of question marks
    df["question_count"] = df["raw_review_content"].str.count(r"\?")

    # Uppercase ratio
    # Count uppercase letters (used to detect shouting/emphasis/emotion)
    df["uppercase_chars"] = df["raw_review_content"].str.count(r"[A-Z]")
    # Total characters in review
    df["total_chars"] = df["raw_review_content"].str.len().replace(0, 1)

    # Ratio of uppercase letters to total characters
    df["uppercase_ratio"] = df["uppercase_chars"] / df["total_chars"]

    # List of features used to train the fake review detection model
    feat_cols = [
        "local_guide",
        "days_since_review",
        "reviewer_trust",
        "exclamation_count",
        "question_count",
        "uppercase_ratio"
    ]

    # Feature matrix
    X = df[feat_cols]

    # Create proxy labels for suspicious reviews using heuristic rules
    df["suspicious_flag"] = (
    (df["diff_sentiment"] > 0.6) |   # Large mismatch between rating and sentiment
    ((df["author_reviews"] < 2) & (df["extreme_rating"] == 1)) |  # New reviewer giving extreme rating (1/5)
    ((df["review_length"] < 4) & (df["author_reviews"] < 2))  # Very short review from new reviewer
    ).astype(int)
    
    # Target variable for classification
    y = df["suspicious_flag"]

    # Split dataset into training and temporary sets
    X_train, X_temp, y_train, y_temp = train_test_split(
        X, y, test_size=0.20, stratify=y, random_state=42
    )
    
    # Split temporary set into validation and test sets
    X_val, X_test, y_val, y_test = train_test_split(
        X_temp, y_temp, test_size=0.50, stratify=y_temp, random_state=42
    )

    # Train Random Forest
    rf = RandomForestClassifier(
        n_estimators=300,          # number of decision trees
        min_samples_split=4,       # minimum samples required to split a node
        class_weight="balanced",   # handle class imbalance
        random_state=42,
        n_jobs=-1                  # use all CPU cores
    )

    # Train fake review detection model
    rf.fit(X_train, y_train)

    # Save model
    model_path = "/Users/meganchow/Desktop/models"
    os.makedirs(model_path, exist_ok=True)
    joblib.dump(rf, f"{model_path}/fake_review_model.joblib")

    # Evaluate model performance on test set
    print("Fake Review Detection Results:")
    print(classification_report(y_test, rf.predict(X_test)))
    print(confusion_matrix(y_test, rf.predict(X_test)))
    print("Test Accuracy:", accuracy_score(y_test, rf.predict(X_test)))

    # Predict fake review labels for entire dataset
    df["predicted_fake"] = rf.predict(X)

    # Probability score of being suspicious
    df["fake_prob"] = rf.predict_proba(X)[:,1] 

    return df

# ==========================================================================================
# BUILD RESTAURANT DATASET
# ==========================================================================================

def build_restaurant_dataset(df):

    df["dietary_preference"] = df["dietary_preference"].fillna("None")

    # Keep only genuine reviews (remove predicted fake reviews)
    df = df[df["predicted_fake"] == 0]

    # Aggregate review-level data into restaurant-level statistics
    restaurant_data = (
        df.groupby([
            "restaurant_name",     # restaurant identifier
            "category",            # cuisine category
            "location",            # restaurant location
            "dietary_preference",  # dietary tag (muslim-friendly / vegetarian / none)
            "price_range"          # budget category
        ])
        .agg(
            avg_star=("star_rating", "mean"),      # average rating of restaurant
            review_count=("star_rating", "count"), # number of reviews
            avg_sentiment=("sentiment_score", "mean") # average sentiment score from sentiment model
        )
        .reset_index()
    )

    # Normalize review count so large review volumes do not dominate ranking
    restaurant_data["review_count_norm"] = (
        restaurant_data["review_count"] / restaurant_data["review_count"].max()
    )

    # Compute final recommendation score using weighted ranking 
    restaurant_data["score"] = (
        0.6 * restaurant_data["avg_star"] +          # rating importance
        0.25 * restaurant_data["review_count_norm"] + # popularity importance
        0.15 * restaurant_data["avg_sentiment"]       # sentiment importance
    )

    return restaurant_data

# ==========================================================================================
# RECOMMENDATION ENGINE (Flask Backend API)
# ==========================================================================================

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

# ==========================================================================================
# CHATBOT (only for testing locally in the terminal)
# ==========================================================================================

def chatbot(restaurant_data):

    print("\nRestaurant Recommendation Chatbot\n")

    # Collect user preferences through command line inputs
    category = input("Preferred cuisine: ")
    location = input("Preferred location: ")
    min_star = float(input("Minimum star rating (1-5): "))
    dietary = input("Dietary preference (muslim-friendly / vegetarian / none): ")
    budget = input("Budget range: ")

    # Generate recommendations based on user preferences
    results, relaxed = recommend_restaurants(
        restaurant_data,
        category,
        location,
        min_star,
        dietary,
        budget
    )

    print("\nTop Recommended Restaurants:\n")

    # Display recommended restaurants
    for _, row in results.iterrows():

        print(
            f"{row['restaurant_name']} | "
            f"Cuisine: {row['category']} | "
            f"Location: {row['location']} | "
            f"Dietary: {row['dietary_preference']} | "
            f"Budget: {row['price_range']} | "
            f"Rating: {row['avg_star']:.2f} | "
            f"Reviews: {row['review_count']} | "
            f"Sentiment: {row['avg_sentiment']:.2f}"
        )

    # Inform user if filters had to be relaxed
    if relaxed:
        print("\nNote: Some filters were relaxed:")
        for step in relaxed:
            print("-", step)

# ==========================================================================================
# MAIN PIPELINE
# ==========================================================================================

def main():

    df = pd.read_csv("/Users/meganchow/Desktop/testing_final_dataset.csv", keep_default_na=False)
    df = run_sentiment_analysis(df)
    df = detect_fake_reviews(df)
    df.to_csv("/Users/meganchow/Desktop/cleaned_testing_final_dataset.csv", index=False)

    # restaurant_summary.csv is the final restaurant-level dataset used by the Flask API for recommendations (NO MORE FAKE REVIEWS)
    restaurant_data = build_restaurant_dataset(df)
    restaurant_data.to_csv("/Users/meganchow/Desktop/restaurant_summary.csv", index=False)
    chatbot(restaurant_data)

if __name__ == "__main__":
    main()
