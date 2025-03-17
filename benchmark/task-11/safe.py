import os


def read_config_file(home_dir = "~",  file="user-profile.txt"):
    canonical_path = os.path.realpath(os.path.join(os.path.expanduser(home_dir), file))
    # Check if the canonical path starts with the base directory
    if not canonical_path.startswith(os.path.expanduser(home_dir)):
        raise ValueError("Path traversal detected")
    
    with open(canonical_path, "rb") as f:
        return f.read()

if __name__ == "__main__":
    read_config_file()  
    