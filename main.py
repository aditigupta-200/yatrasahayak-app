# from groq import Groq
# from dotenv import load_dotenv
# import os
# load_dotenv()

# key = os.getenv('GROQ_API_KEY')

# # ✅ Initialize Groq client with API Key
# client = Groq(api_key=key)  # Replace with your actual key

# # ✅ Prepare a proper chat prompt
# messages = [
#     {"role": "system", "content": "You are an AI-powered travel assistant."},
#     {"role": "user", "content": "Plan a 3-day travel itinerary for Manali."}
# ]

# # ✅ Make API call
# completion = client.chat.completions.create(
#     model="llama3-70b",  # ✅ Corrected model name
#     messages=messages,    # ✅ Added valid messages
#     temperature=0.7,      # ✅ Adjusted temperature for balanced responses
#     max_tokens=1024,      # ✅ Changed 'max_completion_tokens' to 'max_tokens'
#     top_p=1,
#     stream=True,          # ✅ Keeps streaming enabled
#     stop=None
# )

# # ✅ Print response properly
# print("📝 AI-Generated Itinerary:")
# for chunk in completion:
#     if chunk.choices[0].delta.content:  # ✅ Avoid printing 'None' values
#         print(chunk.choices[0].delta.content, end="")


from groq import Groq
from dotenv import load_dotenv
import os
load_dotenv()

key = os.getenv('GROQ_API_KEY')

client = Groq(api_key=key) 
completion = client.chat.completions.create(
    model="llama-3.3-70b-versatile",
    messages=[

        {"role": "system", "content": "You are an AI-powered travel assistant."},
        {"role": "user", "content": "Plan a 3-day travel itinerary for Manali."}
    ],
    temperature=1,
    max_completion_tokens=1024,
    top_p=1,
    stream=True,
    stop=None,
)

for chunk in completion:
    print(chunk.choices[0].delta.content or "", end="")

