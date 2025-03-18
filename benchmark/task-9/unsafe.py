# Reads log on a Mac OS
def load_text_file( file_path = "/var/log/system.log"):
    with open(file_path, 'rb') as f:
        config = f.read()
    return config


if __name__ == "__main__":
    print(load_text_file())  