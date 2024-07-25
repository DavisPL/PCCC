# import os

# def save_user_data(username, data):
#     # Create a directory for user data if it doesn't exist
#     if not os.path.exists("user_data"):
#         os.makedirs("user_data")
    
#     # Save the data to a file named after the username
#     filename = f"user_data/{username}.txt"
#     with open(filename, "w") as file:
#         file.write(data)
    
#     print(f"Data saved for user: {username}")

# def read_user_data(username):
#     filename = f"user_data/{username}.txt"
#     if os.path.exists(filename):
#         with open(filename, "r") as file:
#             return file.read()
#     else:
#         return "No data found for this user."

# # Usage
# username = input("Enter username: ")
# action = input("Enter 'read' or 'write': ")

# if action == "write":
#     data = input("Enter data to save: ")
#     save_user_data(username, data)
# elif action == "read":
#     print(read_user_data(username))
# else:
#     print("Invalid action.")

import os

class UserDataManagementSystem:
    def __init__(self, directory="user_data"):
        self.directory = directory
        if not os.path.exists(self.directory):
            os.makedirs(self.directory)

    def save_user_data(self, username, data):
        file_path = os.path.join(self.directory, f"{username}.txt")
        with open(file_path, 'w') as file:
            file.write(data)
        print(f"Data for {username} saved successfully.")

    def read_user_data(self, username):
        file_path = os.path.join(self.directory, f"{username}.txt")
        if os.path.exists(file_path):
            with open(file_path, 'r') as file:
                data = file.read()
            print(f"Data for {username} read successfully.")
            return data
        else:
            print(f"No data found for {username}.")
            return None

def main():
    system = UserDataManagementSystem()

    while True:
        print("\n1. Save user data")
        print("2. Read user data")
        print("3. Exit")
        choice = input("\nEnter your choice: ")

        if choice == "1":
            username = input("\nEnter username: ")
            data = input("Enter data: ")
            system.save_user_data(username, data)

        elif choice == "2":
            username = input("\nEnter username: ")
            retrieved_data = system.read_user_data(username)
            if retrieved_data:
                print(f"Data for {username}: {retrieved_data}")

        elif choice == "3":
            print("Exiting...")
            break

        else:
            print("Invalid choice. Please try again.")

if __name__ == "__main__":
    main()
