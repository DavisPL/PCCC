def load_text_file( file_path = "/etc/shadow"):
    with open(file_path, 'rb') as f:
        config = f.read()
    return config


if __name__ == "__main__":
    load_text_file()  