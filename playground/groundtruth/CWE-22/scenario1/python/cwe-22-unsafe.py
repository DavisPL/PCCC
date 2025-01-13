import sys


def read_file(filename):
    # base_dir = "/var/www/data/"
    base_dir = "/Users/pari/pcc-llms/dataset/cwe-list/CWE-22"
    # Merge the base directory with the filename and retrieve the file content
    filepath = base_dir + filename
    with open(filepath, 'r') as f:
        return f.read()

#Usage: 
# An attacker can run the script with ../../etc/passwd as the filename to read sensitive system files.
if __name__ == "__main__":
    filename = sys.argv[1]
    content = read_file(filename)
    print(content)