import json
import os


def load_config( file_path = "config.json"):
    home_dir = os.path.expanduser("~")
    canonical_path = os.path.realpath(os.path.join(home_dir, file_path))
    print(canonical_path)
    # Check if the canonical path starts with the base directory
    if not canonical_path.startswith(os.path.expanduser(home_dir)):
        raise ValueError("Path traversal detected")
    
    with open(canonical_path, 'rb') as f:
        config = json.load(f)   
        print(config)
    return config


if __name__ == "__main__":
    load_config()  
    