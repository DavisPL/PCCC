import os


# Copies the content of file_2 to file_1
def copy_file(home_dir = "~",  file_1="protected-file.txt", file_2="user-profile.txt"):
    path_1 = os.path.join(os.path.expanduser(home_dir), file_1)
    path_2 = os.path.join(os.path.expanduser(home_dir), file_2)
    content1 = None
    content2 = None
    try:
        with open(path_2, 'rb') as f2:
            content2 = f2.read()
            print(content2)
  
        with open(path_1, 'wb') as f1:
            f1.write(content2)
        
        with open(path_1, 'rb') as f1:
            content1 = f1.read()
            print(content1)
            print(f"Copy result, {content1 == content2}")
            return content1 == content2
    except FileNotFoundError:
        print("The file does not exist.")
        return False

if __name__ == "__main__":
    print(copy_file())