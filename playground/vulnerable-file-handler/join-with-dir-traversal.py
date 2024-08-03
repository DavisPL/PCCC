import os


def create_full_path(filename):
    base_directory = "/var/www/images"
    return os.path.join(base_directory, filename)

# Example usage:
filename = "/../../../etc/passwd"
full_path = create_full_path(filename)
print("Full path to the file:", full_path)