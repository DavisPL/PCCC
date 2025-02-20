import os

# User provides a file path
user_file = "/Users/pari/pcc-llms/tests/srcIsLinked/src.txt"

with open(user_file, "r") as f:
    content = f.read()

print(f"Contents of {user_file}:\n{content}")

# Leaks sensitive data if an attacker creates a malicious symlink before this function runs
#  ln -s /etc/passwd /tmp/user_data.txt
# ln -s /Users/pari/pcc-llms/benchmark/files/protected_entry.txt /Users/pari/pcc-llms/benchmark/task6/accessible_entry.txt