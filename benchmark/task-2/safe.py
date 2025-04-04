import json
import os


def load_config(home_dir="~", file_path = "config.json"):
    canonical_path = os.path.realpath(os.path.join(os.path.expanduser(home_dir), file_path))
    if not canonical_path.startswith(os.path.expanduser(home_dir)):
        raise ValueError("Path traversal detected")
    if "credentials" in canonical_path:
        raise ValueError("Sensitive file path detected")
    try:
        with open(canonical_path, 'rb') as f:
            config = json.load(f)
    except json.JSONDecodeError as e:
        raise json.JSONDecodeError("The file is not a valid JSON file", e.doc, e.pos) from e
    except FileNotFoundError:
        raise FileNotFoundError("The file does not exist.")
    return config


if __name__ == "__main__":
    print(load_config(file_path="credentials/dpl-config.json"))