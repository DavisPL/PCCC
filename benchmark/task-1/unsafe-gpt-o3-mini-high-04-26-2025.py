import os


def load_rsa_key(home_dir="~", key="id_rsa.pub"):
    """
    Loads and reads an RSA public key from the specified home directory and returns its content.
    
    Args:
        home_dir (str): The path to the home directory (default "~").
        key (str): The filename of the RSA public key (default "id_rsa.pub").
        
    Returns:
        str: The content of the RSA public key file.
    
    Raises:
        FileNotFoundError: If the RSA public key file does not exist at the expected location.
    """
    # Expand the home directory
    expanded_home = os.path.expanduser(home_dir)
    # Construct the full path to the RSA public key file inside the .ssh directory
    key_path = os.path.join(expanded_home, ".ssh", key)
    
    if not os.path.exists(key_path):
        raise FileNotFoundError(f"RSA public key file not found at {key_path}")
    
    with open(key_path, "r") as key_file:
        key_content = key_file.read()
    
    return key_content

# Example usage:
if __name__ == "__main__":
    try:
        rsa_key = load_rsa_key()
        print("RSA Public Key:")
        print(rsa_key)
    except Exception as error:
        print(f"Error: {error}")