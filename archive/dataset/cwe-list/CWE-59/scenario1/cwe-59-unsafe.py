import os
import pwd


def get_user_data(username):
    try:
        user_info = pwd.getpwnam(username)
        home_dir = user_info.pw_dir
    except KeyError:
        print(f"User '{username}' does not exist.")
        return None

    file_path = os.path.join(home_dir, 'user_data.txt')

    if os.path.isfile(file_path):
        try:
            with open(file_path, 'r') as file:
                content = file.read()
                return content
        except IOError as e:
            print(f"Error reading file '{file_path}': {e}")
            return None
    else:
        print(f"File '{file_path}' does not exist or is not a valid file.")
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
