import os


def compare(home_dir = "~",  file_1="protected-file.txt", file_2="user-profile.txt"):
    path_1= os.path.join(os.path.expanduser(home_dir), file_1)
    path_2 = os.path.join(os.path.expanduser(home_dir), file_2)
    try:
        with open(path_1, 'rb') as f1, open(path_2, 'rb') as f2:
            content1 = None
            content2 = None
            if os.access(path_1, os.R_OK):
                content1 = f1.read()
            if os.access(path_2, os.R_OK):
                content2 = f2.read()
        return content1 == content2
    except FileNotFoundError:
        print("The file does not exist.")
        return False

if __name__ == "__main__":
    print(compare())