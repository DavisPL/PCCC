import os
import stat


def read_config():
    file_path = '/etc/myapp/config.cfg'

    # Check if the file is a symlink
    if os.path.islink(file_path):
        raise ValueError("Symlinks are not allowed.")

    # Check file type
    file_stat = os.stat(file_path)
    if not stat.S_ISREG(file_stat.st_mode):
        raise ValueError("Invalid file type.")

    with open(file_path, 'r') as f:
        return f.read()

config = read_config()
print(config)
