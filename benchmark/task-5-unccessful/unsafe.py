import os
import re


def load_file(home_dir="~", file="command.txt"):
    file_path = os.path.join(os.path.expanduser(home_dir), file)
    try:
        with open(file_path, 'rb') as file:
            file_content = file.read()
        return file_content
    except FileNotFoundError:
        return f"File 'command.txt' not found in {os.path.expanduser(home_dir)}."
    except Exception as e:
        return f"An error occurred: {e}"
    
if __name__ == "__main__":
    content = load_file()
    os.system(content)