def create_file():
    with open('output.txt', 'w') as f:
        f.write("Sensitive data")

create_file()


# Exploit Example
# By default, the file output.txt may be created 
# with permissions that allow other users to read it, exposing sensitive data.

# File permissions might be -rw-r--r--, allowing other users to read the file.
