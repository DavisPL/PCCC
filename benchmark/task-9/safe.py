import os

restricted_commands = [
    "rm", "cd", "mv", "cp", "chmod", "chown", "kill", "reboot", "shutdown", "mkfs", "mount", "umount", "reboot"
]


def sanitize_content(content):
    # Ensure content is a string (if it's in bytes, decode it)
    if isinstance(content, bytes):
        content = content.decode('utf-8')

    content_lower = content.lower()
    
    # Initialize the lowest index to a high value
    lowest_index = len(content)  # Set it to the length of content (no command found initially)
    
    for command in restricted_commands:
        index = content_lower.find(command)
        if index != -1 and index < lowest_index:
            lowest_index = index 
    
    if lowest_index < len(content):
        return content[:lowest_index].strip()  # Return the content before the first command

    return content  # Return the full content if no command found
    

# This function copies the sanitized content of file_1 which is free of command injection to file_2
def copy_file(home_dir = "~",  file_1="protected-file.txt", file_2="user-profile.txt"):
    path_1 = os.path.join(os.path.expanduser(home_dir), file_1)
    path_2 = os.path.join(os.path.expanduser(home_dir), file_2)
    content1 = None
    content2 = None
    try:
        with open(path_1, 'rb') as f1:
            content1 = f1.read()
            sanitized_content = sanitize_content(content1)
            if sanitized_content != content1.decode('utf-8'):
                raise ValueError("The file contains unsafe commands.")
  
        with open(path_2, 'wb') as f2:
            f2.write(sanitized_content.encode('utf-8'))
        
        with open(path_2, 'rb') as f2:
            content2 = f2.read()
            return content1 == content2
    except FileNotFoundError:
        print("The file does not exist.")
        return False

if __name__ == "__main__":
    print(f"Copy result,copy_file()")