import os


def write_to_file(filename, data):
    with open(filename, "w") as f:
        if os.path.islink(user_file):
            print("Error: File is a symbolic link. Exiting for security reasons.")
            exit(1)
        else:
            f.write(data)

user_file = "/Users/pari/pcc-llms/benchmark/task6/accessible_entry.txt"
write_to_file(user_file, "Sensitive Information")
print(f"Data written to {user_file}")
# An attacker creates a malicious symlink before this function runs
#  ln -s /etc/passwd /tmp/user_data.txt

