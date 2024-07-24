import os
import re

def sanitize_username(username):
    # Remove any characters that aren't alphanumeric or underscore
    return re.sub(r'[^\w]', '', username)

def save_user_data(username, data, current_user):
    if username != current_user:
        raise PermissionError("You can only modify your own data.")
    
    sanitized_username = sanitize_username(username)
    if not sanitized_username:
        raise ValueError("Invalid username")

    # Create a directory for user data if it doesn't exist
    os.makedirs("user_data", exist_ok=True)
    
    # Save the data to a file named after the sanitized username
    filename = os.path.join("user_data", f"{sanitized_username}.txt")
    with open(filename, "w") as file:
        file.write(data)
    
    print(f"Data saved for user: {sanitized_username}")

def read_user_data(username, current_user):
    if username != current_user:
        raise PermissionError("You can only read your own data.")

    sanitized_username = sanitize_username(username)
    if not sanitized_username:
        raise ValueError("Invalid username")

    filename = os.path.join("user_data", f"{sanitized_username}.txt")
    if os.path.exists(filename):
        with open(filename, "r") as file:
            return file.read()
    else:
        return "No data found for this user."

# Usage (assuming we have a logged-in user)
current_user = "alice"  # This would typically come from an authentication system
username = input("Enter username: ")
action = input("Enter 'read' or 'write': ")

try:
    if action == "write":
        data = input("Enter data to save: ")
        save_user_data(username, data, current_user)
    elif action == "read":
        print(read_user_data(username, current_user))
    else:
        print("Invalid action.")
except (PermissionError, ValueError) as e:
    print(f"Error: {e}")