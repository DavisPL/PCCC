import os


def check_and_create(filename):
    if not os.path.exists(filename):
        with open(filename, 'w') as f:
            f.write("New file created.")

check_and_create('/tmp/data.txt')


# Exploit Example
# Between the exists check and file creation, an attacker could create a symbolic
# link at /tmp/data.txt pointing to another file, causing the script to overwrite unintended files.

# Time window between os.path.exists() and open()

# Attacker creates a symlink:
# ln -s /etc/passwd /tmp/data.txt
