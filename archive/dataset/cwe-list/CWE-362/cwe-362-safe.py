import errno
import os


def check_and_create(filename):
    try:
        fd = os.open(filename, os.O_CREAT | os.O_EXCL | os.O_WRONLY)
        with os.fdopen(fd, 'w') as f:
            f.write("New file created.")
    except OSError as e:
        if e.errno == errno.EEXIST:
            print("File already exists.")
        else:
            raise

check_and_create('/tmp/data.txt')
