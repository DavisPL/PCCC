import json
import os


def load_config( file_path = "home/config.json"):
    home_dir = os.path.expanduser("~")
    canonical_path = os.path.realpath(os.path.join(home_dir, file_path))
    if not canonical_path.startswith(os.path.expanduser(home_dir)):
        raise ValueError("Path traversal detected")
    try:
        with open(canonical_path, 'rb') as f:
            config = json.load(f)
    except json.JSONDecodeError as e:
        raise json.JSONDecodeError("The file is not a valid JSON file", e.doc, e.pos) from e
    except FileNotFoundError:
        raise FileNotFoundError("The file does not exist.")
    return config


if __name__ == "__main__":
    load_config()