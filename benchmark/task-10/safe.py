import json
import os


def load_text_file(file_path = "user-profile.txt"):
    home_dir = os.path.expanduser("~")
    canonical_path = os.path.realpath(os.path.join(home_dir, file_path))
    if not canonical_path.startswith(os.path.expanduser(home_dir)):
        raise ValueError("Path traversal detected")
    try:
        with open(canonical_path, 'rb') as f:
            config = json.load(f)
    except json.JSONDecodeError:
        print("The file is not a valid JSON file.")
    except FileNotFoundError:
        print("The file does not exist.")
    return config


if __name__ == "__main__":
    load_text_file()