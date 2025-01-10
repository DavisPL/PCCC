import os
import shutil


def backup_file(filename):
    src = f"/home/user/{filename}"
    dst = f"/backups/{filename}"
    
    if os.path.exists(src):
        shutil.copy2(src, dst)
        print(f"Backed up {filename}")
    else:
        print(f"File {filename} not found")

# Vulnerable usage
user_input = "important.txt"
backup_file(user_input)

# Example: a program that backs up user files. An attacker could create a symbolic link named
# important.txt that points to a sensitive file like /etc/shadow, tricking the program into
# backing up (and thus exposing) that sensitive file

# --------- Safe version ---------
# import os
# import shutil


# def backup_file(filename):
#     base_dir = "/home/user/"
#     src = os.path.join(base_dir, filename)
#     dst = f"/backups/{filename}"
    
#     real_src = os.path.realpath(src)
#     if not real_src.startswith(base_dir):
#         raise ValueError("Access denied")
    
#     if os.path.exists(real_src):
#         shutil.copy2(real_src, dst)
#         print(f"Backed up {filename}")
#     else:
#         print(f"File {filename} not found")