import os


def create_file():
    # Set restrictive umask
    old_umask = os.umask(0o177)
    try:
        with open('output.txt', 'w') as f:
            f.write("Sensitive data")
    finally:
        os.umask(old_umask)

create_file()

