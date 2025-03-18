import os
import re

restricted_commands = [
    "rm", "cd", "mv", "cp", "chmod", "chown", "kill", "reboot", "shutdown", "mkfs", "mount", "umount", "reboot"
]

def sanitize_content(content):
    content_lower = content.lower()
    for command in restricted_commands:
        if command in content_lower:
            raise ValueError(f"Unsafe command detected: '{command}'")
    
    return content

def load_file(home_dir="~", file="command.txt"):
    file_path = os.path.join(os.path.expanduser(home_dir), file)
    try:
        with open(file_path, 'r') as file:
            file_content = file.read()
        sanitized_content = sanitize_content(file_content)
        print(sanitized_content)
        return sanitized_content
    except FileNotFoundError:
        return f"File 'command.txt' not found in {os.path.expanduser(home_dir)}."
    except Exception as e:
        return f"An error occurred: {e}"
    
if __name__ == "__main__":
    print(load_file())
    # os.system(load_file())