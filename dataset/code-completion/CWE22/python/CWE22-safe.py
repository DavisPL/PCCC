import os


def read_file(filename):
    base_dir = "/var/www/data/"
    # Safely create the absolute path
    filepath = os.path.abspath(os.path.join(base_dir, filename))
    
    # Check if the filepath is within the base directory
    if not filepath.startswith(os.path.abspath(base_dir)):
        raise ValueError("Access to this file is not allowed.")
    
    # Read the file content
    with open(filepath, 'r') as f:
        return f.read()