import pandas as pd
import numpy as np
from sklearn.metrics import accuracy_score
from sklearn.preprocessing import OneHotEncoder, MinMaxScaler
from sklearn.neighbors import NearestNeighbors
import joblib

# Load Dataset
df = pd.read_csv("modified_dataset.csv")

# ✅ Load Saved Encoders & Model
encoder = joblib.load("encoder.pkl")
scaler = joblib.load("scaler.pkl")
knn_model = joblib.load("knn_travel_model.pkl")

# ✅ Recommendation Function (Fixed Bug)
def recommend_travel(place_type, k=3):
    # Filter dataset for given type
    input_data = df[df["Type"] == place_type][["Type", "Best Season to Visit"]]

    if input_data.empty:
        print(f"❌ No data found for category: {place_type}")
        return np.array([])  # Return empty NumPy array

    # Encode the input using the same encoder (Ensures correct feature count)
    encoded_input = encoder.transform(input_data)

    # Fix feature mismatch by padding with zeros if necessary
    expected_features = knn_model.n_features_in_
    if encoded_input.shape[1] < expected_features:
        padding = np.zeros((encoded_input.shape[0], expected_features - encoded_input.shape[1]))
        encoded_input = np.hstack((encoded_input, padding))

    # Ensure input is in correct shape for kneighbors()
    encoded_input = encoded_input.reshape(1, -1)

    # Get nearest neighbors
    distances, indices = knn_model.kneighbors(encoded_input)

    # Get recommended places
    recommended_places = df.iloc[indices[0]]["Type"].values
    return recommended_places

# ✅ Evaluate KNN Model (Fixed Bug)
def evaluate_knn(k=3):
    print("🔍 Evaluating Travel Recommendation Model...")

    y_true = []
    y_pred = []

    for true_place in df["Type"].unique():
        recommended_places = recommend_travel(true_place, k)

        # ✅ Fix: Use `.size == 0` to check if array is empty
        if recommended_places.size == 0:
            y_pred.append("Unknown")
        else:
            y_pred.append(recommended_places[0])  # Pick top recommendation

        y_true.append(true_place)

    # Accuracy Calculation
    accuracy = accuracy_score(y_true, y_pred)
    print(f"📊 Model Accuracy: {accuracy * 100:.2f}%")

# ✅ Run the Evaluation
if __name__ == "__main__":
    evaluate_knn(k=3)
