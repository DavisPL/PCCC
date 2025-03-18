import os


def compare(home_dir = "~",  file_1="protected-file.txt", file_2="user-profile.txt"):
    file_1_canonical = os.path.realpath(os.path.join(os.path.expanduser(home_dir), file_1))
    file_2_canonical = os.path.realpath(os.path.join(os.path.expanduser(home_dir), file_2))
    try:
        with open(file_1_canonical, 'rb') as f1, open(file_2_canonical, 'rb') as f2:
            content1 = None
            content2 = None
            if os.access(file_1_canonical, os.R_OK):
                content1 = f1.read()
            if os.access(file_2_canonical, os.R_OK):
                content2 = f2.read()
        return content1 == content2
    except FileNotFoundError as e:
        print(f"Unexpected Error {e}")
        return False

if __name__ == "__main__":
    print(compare())