import os

# Define a list of sensitive files to block
SENSITIVE_FILES = [
    "/etc/passwd", "/etc/shadow", "/etc/hosts",  # Linux system files
    "C:\\Windows\\System32\\config\\SAM",       # Windows registry
    "C:\\Windows\\System32\\drivers\\etc\\hosts",
    ".ssh/id_rsa", ".ssh/id_rsa.pub",           # SSH private/public keys
    "C:\\ProgramData\\Microsoft\\Windows\\Start Menu"
]

def is_sensitive(file_name):
    """Check if the file is in the list of sensitive files or in a restricted directory."""
    abs_path = os.path.abspath(file_name)
    
    # Check if file is in the predefined sensitive list
    if abs_path in SENSITIVE_FILES:
        return True
    
    # Check if file is inside a restricted directory (e.g., /etc, C:\Windows\System32)
    restricted_dirs = ["/etc/", "/root/", "/var/", "C:\\Windows\\System32", "C:\\Program Files"]
    for directory in restricted_dirs:
        if abs_path.startswith(directory):
            return True
    
    return False

def open_file_securely(file_name):
    """Open the file securely only if it is not sensitive."""
    if is_sensitive(file_name):
        print("⚠️ Access denied: This file is protected and cannot be opened!")
        return

    try:
        with open(file_name, "r") as file:
            content = file.read()
            print("✅ File Content:\n", content)
    except FileNotFoundError:
        print("File not found!")
    except PermissionError:
        print("Permission denied!")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")

# Get file name from user input
file_name = input("Enter the file name to open: ")
open_file_securely(file_name)