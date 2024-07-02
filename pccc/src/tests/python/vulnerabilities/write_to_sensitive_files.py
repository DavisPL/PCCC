def write_to_file(file_path, content):
    try:
        with open(file_path, 'w') as file:
            file.write(content)
        print("Content successfully written to the file.")
    except PermissionError:
        print(f"You don't have permission to write to {file_path}.")
    except Exception as e:
        print(f"An error occurred: {e}")

def main():
    sensitive_file = 'src/files/sensitive_file.txt'
    content = "This content was written without proper access control."

    write_to_file(sensitive_file, content)

if __name__ == "__main__":
    main()
    
    
