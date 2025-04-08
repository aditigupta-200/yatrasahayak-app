import pandas as pd
import numpy as np
from sklearn.preprocessing import OneHotEncoder, MinMaxScaler
from sklearn.neighbors import NearestNeighbors
import joblib
import requests

# Groq API Key (replace with your actual key)
GROQ_API_KEY = "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"

# Load Dataset
dataset_path = "../backend/data/modified_dataset.csv"  # Update if needed
df = pd.read_csv("modified_dataset.csv")

# ✅ Step 1: Preprocess Data
print("🔄 Preprocessing dataset...")
features = ["Type", "Google review rating", "Entrance Fee in INR", "Best Season to Visit"]
df = df[features].dropna()

# One-Hot Encoding
encoder = OneHotEncoder(sparse_output=False)

encoded_features = encoder.fit_transform(df[["Type", "Best Season to Visit"]])

# Normalize numerical values
scaler = MinMaxScaler()
scaled_features = scaler.fit_transform(df[["Google review rating", "Entrance Fee in INR"]])

# Combine features
X = np.hstack((encoded_features, scaled_features))

# Save encoders
joblib.dump(encoder, "encoder.pkl")
joblib.dump(scaler, "scaler.pkl")
np.save("preprocessed_data.npy", X)

print("✅ Data Preprocessing Complete! Shape:", X.shape)

# ✅ Step 2: Train KNN Model
print("🔄 Training KNN model...")
knn = NearestNeighbors(n_neighbors=5, metric='euclidean')
knn.fit(X)

# Save trained model
joblib.dump(knn, "knn_travel_model.pkl")
print("✅ KNN Model Trained & Saved!")

# ✅ Step 3: Recommendation Function
def recommend_travel(place_type):
    # Filter dataset for given type (category)
    input_data = df[df["Type"] == place_type][["Type", "Best Season to Visit"]]

    # ✅ Check if input_data is empty
    if input_data.empty:
        print(f"❌ No data found for category: {place_type}")
        return []

    # Encode the input
    encoded_input = encoder.transform(input_data)

    # Find nearest neighbors using knn_model
    distances, indices = knn.kneighbors(encoded_input)

    # Get recommended places
    recommended_places = df.iloc[indices[0]]["Type"].values
    return recommended_places


# ✅ Step 4: AI-Powered Itinerary Generator (Groq API)
def get_itinerary(destination):
    print(f"📝 Generating itinerary for {destination}...")

    url = "https://api.groq.com/v1/chat/completions"
    headers = {"Authorization": f"Bearer {GROQ_API_KEY}"}
    
    prompt = f"Create a 3-day travel itinerary for {destination} with places to visit and activities."

    payload = {
        "model": "llama3-70b",
        "messages": [
            {"role": "system", "content": "You are a travel assistant."},
            {"role": "user", "content": prompt}
        ]
    }

    response = requests.post(url, json=payload, headers=headers)
    return response.json()["choices"][0]["message"]["content"]

# ✅ Step 5: Run the Full Pipeline
if __name__ == "__main__":
    print("\n🔹 Travel Recommendation System is Ready! 🔹\n")

    # Test Recommendation
    test_place = "National Park"
    recommendations = recommend_travel(test_place)
    print(f"🌍 Recommended places similar to {test_place}: {recommendations}")

    # Test Itinerary Generation
    test_destination = "Manali"
    itinerary = get_itinerary(test_destination)
    print(f"\n📝 AI-Generated Itinerary for {test_destination}:\n{itinerary}")
