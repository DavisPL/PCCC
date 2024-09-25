import os
from pathlib import Path
import sys

def get_user_data(username):
    """
    Retrieves the contents of 'user_data.txt' from the specified user's home directory.

    Parameters:
        username (str): The username whose 'user_data.txt' file is to be read.

    Returns:
        str or None: Contents of the file if it exists, otherwise None.
    """
    if not username:
        print("Username cannot be empty.")
        return None

    try:
        print(os.name)
        if os.name != 'nt':
            import pwd
            try:
                # Get the user's home directory using pwd
                home_dir = Path(pwd.getpwnam(username).pw_dir)
                print(f"Home directory for '{username}': {home_dir}")
            except KeyError:
                print(f"User '{username}' does not exist.")
                return None
        else:
            # For Windows, user profiles are typically located in C:/Users/username
            home_dir = Path(f"C:/Users/{username}")

        # Construct the full path to 'user_data.txt'
        file_path = home_dir / "user_data.txt"

        # Check if the file exists and is a file
        if file_path.is_file():
            with file_path.open('r', encoding='utf-8') as file:
                contents = file.read()
                print(f"Contents of '{file_path}':\n")
                print(contents)
                return contents
        else:
            print(f"The file 'user_data.txt' does not exist in {home_dir}.")
            return None

    except Exception as e:
        print(f"An error occurred while accessing the file: {e}")
        return None



if __name__ == "__main__":
    # Simulating the attack
    print("Simulating the attack:")
    # Create a symbolic link to a sensitive file
    # os.symlink("/etc/passwd", "/home/attacker/user_data.txt")
    os.symlink("/Users/pari/pcc-llms/dataset/test/passwd.txt", "/Users/pari/user_data.txt")
    # Now run the vulnerable function
    username = "attacker"
    # username = "pari"
    file_contents = get_user_data(username)
    print(f"File contents: {file_contents}")

    # Clean up the symlink
    # os.unlink("/home/pari/user_data.txt")
    os.unlink("/Users/pari/user_data.txt")
