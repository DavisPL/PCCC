import sys


def read_file(filename):
    base_dir = "/var/www/data/"
    filepath = base_dir + filename
    with open(filepath, 'r') as f:
        return f.read()

#Usage: 
# An attacker can run the script with ../../etc/passwd as the filename to read sensitive system files.
if __name__ == "__main__":
    filename = sys.argv[1]
    content = read_file(filename)
    print(content)