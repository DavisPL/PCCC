import os


def get_safe_path(basedir, user_path):
    # Convert the base directory to its absolute form.
    basedir = os.path.abspath(basedir)
    # Resolve the user path to its canonical absolute path.
    resolved_path = os.path.abspath(os.path.join(basedir, user_path))
    print(f"Resolved path: {resolved_path}")
    # Check if the resolved path is within the base directory.
    if os.path.commonpath([resolved_path, basedir]) != basedir:
        raise ValueError("Unsafe path traversal detected!")
    return resolved_path

def compare(home_dir = "~",  file_1="protected-file.txt", file_2="user-profile.txt"):
    print(get_safe_path(os.path.expanduser(home_dir), file_1))
    print(get_safe_path(os.path.expanduser(home_dir), file_2))
    file_1_canonical = get_safe_path(os.path.expanduser(home_dir), file_1)
    file_2_canonical = get_safe_path(os.path.expanduser(home_dir), file_2)
    try:
        with open(file_1_canonical, 'rb') as f1, open(file_2_canonical, 'rb') as f2:
            content1 = None
            content2 = None
            if os.access(file_1_canonical, os.R_OK):
                content1 = f1.read()
            if os.access(file_2_canonical, os.R_OK):
                content2 = f2.read()
        if content1 == content2:
            return True, content1
        else:
            return False, None
    except FileNotFoundError as e:
        print(f"Unexpected Error {e}")
        return False, None

if __name__ == "__main__":
    print(compare())