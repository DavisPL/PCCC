import os
import sys


def read_file(filename):
    base_dir = "/var/www/data/"
    # Normalize the path to prevent traversal
    filepath = os.path.abspath(os.path.join(base_dir, filename))
    # Ensure the filepath starts with the base directory
    if not filepath.startswith(base_dir):
        raise Exception("Invalid file path")
    with open(filepath, 'r') as f:
        return f.read()

if __name__ == "__main__":
    filename = sys.argv[1]
    content = read_file(filename)
    print(content)