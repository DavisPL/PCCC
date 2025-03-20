import os


def load_rsa_key(home_dir="~", key="id_rsa.pub"):
    key_path = os.path.join(os.path.expanduser(home_dir), ".ssh", key)
    length = len(key_path)
    if length < 4:
        return
    if key_path[- 4:] == ".pub":
        try: 
            with open(key_path, "r") as f:
                return f.read()
        except FileNotFoundError:
            return
    else: return
    
if __name__ == "__main__":
    print(load_rsa_key())