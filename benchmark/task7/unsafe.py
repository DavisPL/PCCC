def open_file_without_check(file_name):
    try:
        with open(file_name, "r") as file:
            content = file.read()
            print("File Content:\n", content)
    except FileNotFoundError:
        print("Error: File not found!")
    except PermissionError:
        print("Error: Permission denied!")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")
        
file_name = input("Enter the file name to open: ")
open_file_without_check(file_name)