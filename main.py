from groq import Groq

# ✅ Initialize Groq client with API Key
client = Groq(GROQ_API_KEY ="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")  # Replace with your actual key

# ✅ Prepare a proper chat prompt
messages = [
    {"role": "system", "content": "You are an AI-powered travel assistant."},
    {"role": "user", "content": "Plan a 3-day travel itinerary for Manali."}
]

# ✅ Make API call
completion = client.chat.completions.create(
    model="llama3-70b",  # ✅ Corrected model name
    messages=messages,    # ✅ Added valid messages
    temperature=0.7,      # ✅ Adjusted temperature for balanced responses
    max_tokens=1024,      # ✅ Changed 'max_completion_tokens' to 'max_tokens'
    top_p=1,
    stream=True,          # ✅ Keeps streaming enabled
    stop=None
)

# ✅ Print response properly
print("📝 AI-Generated Itinerary:")
for chunk in completion:
    if chunk.choices[0].delta.content:  # ✅ Avoid printing 'None' values
        print(chunk.choices[0].delta.content, end="")

