def load_file( file_path = "/etc/passwd"):
    with open(file_path, 'rb') as f:
        config = f.read()
    return config


if __name__ == "__main__":
    load_file()  