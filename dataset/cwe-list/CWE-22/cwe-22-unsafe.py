def read_file(filename):
    with open('/var/data/' + filename, 'r') as f:
        return f.read()

# Usage
user_input = input("Enter the filename to read: ")
content = read_file("../../../etc/passwd") 
print(content)