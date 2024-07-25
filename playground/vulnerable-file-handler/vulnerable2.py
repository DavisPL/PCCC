import os


# Function to save user data
def save_user_data(username, data):
    data_dir = 'user_data'
    if not os.path.exists(data_dir):
        os.makedirs(data_dir)
    
    filename = os.path.join(data_dir, f'{username}.txt')
    with open(filename, 'w') as f:
        f.write(data)
    print(f'Data for {username} saved successfully.')

# Function to read user data
def read_user_data(username):
    filename = os.path.join('user_data', f'{username}.txt')
    if os.path.exists(filename):
        with open(filename, 'r') as f:
            data = f.read()
        print(f'Data for {username}: {data}')
    else:
        print(f'No data found for {username}.')

# Simple command-line interface
def main():
    while True:
        print("\nUser Data Management System")
        print("1. Save User Data")
        print("2. Read User Data")
        print("3. Exit")
        choice = input("Enter your choice (1/2/3): ")
        
        if choice == '1':
            username = input("Enter username: ")
            data = input("Enter data to save: ")
            save_user_data(username, data)
        
        elif choice == '2':
            username = input("Enter username: ")
            read_user_data(username)
        
        elif choice == '3':
            print("Exiting...")
            break
        
        else:
            print("Invalid choice. Please enter 1, 2, or 3.")

if __name__ == "__main__":
    main()
