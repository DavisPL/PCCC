import os


def load_text_file(home_dir = "~",  file="/../../etc/passwd"):
    file_dir = os.path.join(os.path.expanduser(home_dir), file)
    with open(file_dir, "rb") as f:
        return f.read()

if __name__ == "__main__":
    load_text_file()  