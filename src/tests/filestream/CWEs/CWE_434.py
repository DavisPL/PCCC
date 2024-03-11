import os


def save_file_with_insecure_permissions(file_path, content):
    try:
        with open(file_path, 'w') as file:
            file.write(content)
            # Insecure permission assignment
            os.chmod(file_path, 0o777)  # Setting world-writable permissions
        print("File saved successfully to:", file_path)
    except Exception as e:
        print("An error occurred:", e)

if __name__ == "__main__":
    # Get the content to be saved in the file
    content = input("Enter the content to save in the file: ")

    # Get the path where the file will be saved
    file_path = input("Enter the path of the file to save: ")

    # Call the function to save the file
    save_file_with_insecure_permissions(file_path, content)
