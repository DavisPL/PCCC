def read_file(file_name):
    try:
        # Insecure directory traversal
        file_path = "./Files/" + file_name
        with open(file_path, 'r') as file:
            content = file.read()
            print("File Content:")
            print(content)
    except FileNotFoundError:
        print(f"File '{file_name}' not found.")
    except Exception as e:
        print(f"Error occurred: {e}")

if __name__ == "__main__":
    user_input = input("Enter the file name to read: ")
    read_file(user_input)