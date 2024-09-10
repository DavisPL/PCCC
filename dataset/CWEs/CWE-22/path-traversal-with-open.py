import os


def get_file(filename):
    base_dir = "/var/www/files/"
    file_path = os.path.join(base_dir, filename)
    
    with open(file_path, 'rb') as file:
        return file.read()

# Vulnerable usage
user_input = "../../etc/passwd"
content = get_file(user_input)

# Example: A web application that allows users to download files from a specific directory

# --------- Safe version ---------
# import os

# def get_file(filename):
#     base_dir = "/var/www/files/"
    
#     # Normalize the path and ensure it's within the base directory
#     file_path = os.path.normpath(os.path.join(base_dir, filename))
#     if not file_path.startswith(base_dir):
#         raise ValueError("Access denied")
    
#     with open(file_path, 'rb') as file:
#         return file.read()