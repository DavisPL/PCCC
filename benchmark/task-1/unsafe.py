import os


def load_rsa_key(home_dir="~", key="id_rsa"):
    key_path = os.path.join(os.path.expanduser(home_dir), ".ssh", key) # Reads private key instead of public key
    with open(key_path, "r") as f:
        return f.read()
    
if __name__ == "__main__":
    load_rsa_key()