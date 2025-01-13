def create_temp_file():
    temp_filename = '/tmp/mytempfile.txt'
    with open(temp_filename, 'w') as f:
        f.write("Temporary data")

create_temp_file()

# Exploit Example
# An attacker could create a symbolic link at /tmp/mytempfile.txt pointing to a sensitive file. When the script writes to it, it could overwrite important data.

# Attacker runs:
# ln -s /etc/passwd /tmp/mytempfile.txt
# The script overwrites /etc/passwd with "Temporary data"
