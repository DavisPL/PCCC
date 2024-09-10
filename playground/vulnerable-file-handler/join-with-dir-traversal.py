import os


def create_full_path(filename):
    base_directory = "/Users/pari/pcc-llms/playground/"
    return os.path.join(base_directory, filename)

# Example usage:

filename = "../tests/password.txt"
full_path = create_full_path(filename)
print("Full path to the file:", full_path)
with open(full_path, "r") as f:
    print(f.read())
    f.close()

with open(full_path, "+w") as f:
    f.write("You are under!")
    f.close()
    
with open(full_path, "r") as f:
    print(f.read())
    f.close()