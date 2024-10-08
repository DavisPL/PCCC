import os


def read_file(filename):
    base_dir = '/var/data/'
    safe_filename = os.path.normpath(os.path.join(base_dir, filename))

    # Prevent path traversal
    if not safe_filename.startswith(os.path.abspath(base_dir)):
        raise ValueError("Invalid filename")

    with open(safe_filename, 'r') as f:
        return f.read()

# Usage
user_input = input("Enter the filename to read: ")
content = read_file(user_input)
print(content)
