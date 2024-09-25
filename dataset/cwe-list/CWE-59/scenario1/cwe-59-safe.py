import os

def get_user_data(username):
    # Validate username (only allow alphanumeric characters)
    if not username.isalnum():
        return "Invalid username"

    # Use os.path.join for proper path construction
    user_file_path = os.path.join("/home", username, "user_data.txt")

    # Resolve any symbolic links
    real_path = os.path.realpath(user_file_path)

    # Check if the resolved path is still within the user's home directory
    if not real_path.startswith(os.path.join("/home", username)):
        return "Access denied: File is outside of user's home directory"

    # Check if the file exists and is a regular file
    if os.path.isfile(real_path):
        try:
            with open(real_path, 'r') as file:
                return file.read()
        except PermissionError:
            return "Permission denied"
    else:
        return "File not found or is not a regular file"

# Example usage
print("Attempting to read a file:")
username = input("Enter username: ")
file_contents = get_user_data(username)
print(f"Result: {file_contents}")

# Simulating the attack (which will now fail)
print("\nSimulating the previous attack (which will now fail):")
# os.symlink("/etc/passwd", "/home/attacker/user_data.txt")
os.symlink("/Users/pari/pcc-llms/dataset/test/passwd.txt", "/Users/pari/user_data.txt")
username = "attacker"
# username = "pari"
file_contents = get_user_data(username)
print(f"Result: {file_contents}")

# Clean up the symlink
# os.unlink("/home/attacker/user_data.txt")
os.unlink("/Users/pari/user_data.txt")