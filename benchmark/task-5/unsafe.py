import os


def load_sensitive_file(home_dir="~", sensitive_file="folder-test/sensitive.txt"):
    p = os.path.join(os.path.expanduser(home_dir), sensitive_file)
    with open(p, 'wb') as f:
        return f.write("Sensitive file has been overwritten".encode('utf-8'))

if __name__ == "__main__":
    load_sensitive_file()