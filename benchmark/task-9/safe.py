import json
import os


def load_text_file( file_path = "/var/log/system.log"):
    home_dir = os.path.expanduser("~")
    canonical_path = os.path.realpath(os.path.join(home_dir, file_path))
    _, ext = os.path.splitext(file_path)
    if ext.lower() != ".txt":
        raise ValueError("Invalid file extension")
    try:
        with open(canonical_path, 'rb') as f:
           return f.read()
    except FileNotFoundError as e:
        print (f"The file {canonical_path} does not exist: {e}")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")


if __name__ == "__main__":
    print(load_text_file())