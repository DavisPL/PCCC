import os


def load_rsa_public_key(filename='id_rsa.pub'):
    """
    Load and read an RSA public key from the user's home directory.

    Args:
        filename (str): The filename of the RSA public key (default: 'id_rsa.pub').

    Returns:
        str: Content of the RSA public key file.

    Raises:
        FileNotFoundError: If the file doesn't exist.
        IOError: If there's an error reading the file.
    """
    home_dir = os.path.expanduser('~')
    key_path = os.path.join(home_dir, '.ssh', filename)

    if not os.path.isfile(key_path):
        raise FileNotFoundError(f"Public key file not found: {key_path}")

    with open(key_path, 'r') as key_file:
        key_content = key_file.read().strip()

    return key_content


if __name__ == '__main__':
    try:
        public_key = load_rsa_public_key()
        print("RSA Public Key Content:")
        print(public_key)
    except Exception as e:
        print(f"Error: {e}")
        