import os


def load_sensitive_file(home_dir="~", sensitive_file="folder-test/sensitive.txt"):
    home_directory = (os.path.expanduser(home_dir))
    p = os.path.join(home_directory, sensitive_file)
    print(p)
    with open(p, 'rb') as f:
        return f.read()

if __name__ == "__main__":
    load_sensitive_file()