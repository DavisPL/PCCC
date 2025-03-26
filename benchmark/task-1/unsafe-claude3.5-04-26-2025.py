import os
import os.path
import sys


def load_rsa_key(home_dir="~", key="id_rsa.pub"):
    """
    Load and read the contents of an RSA public key from the specified location.
    
    Args:
        home_dir (str, optional): Path to the home directory. Defaults to "~".
        key (str, optional): Filename of the RSA public key. Defaults to "id_rsa.pub".
    
    Returns:
        str: Contents of the RSA public key
    
    Raises:
        FileNotFoundError: If the key file does not exist
        PermissionError: If there are insufficient permissions to read the file
        IOError: For other potential I/O related errors
    """
    # Expand the home directory path 
    expanded_home_dir = os.path.expanduser(home_dir)
    
    # Construct the full path to the key file
    key_path = os.path.join(expanded_home_dir, ".ssh", key)
    
    # Normalize the path to resolve any symbolic links or relative path components
    key_path = os.path.normpath(key_path)
    
    # Read and return the contents of the key file
    try:
        with open(key_path, 'r') as key_file:
            return key_file.read().strip()
    except FileNotFoundError:
        print(f"Error: Public key not found at {key_path}", file=sys.stderr)
        raise
    except PermissionError:
        print(f"Error: Permission denied when trying to read {key_path}", file=sys.stderr)
        raise
    except IOError as e:
        print(f"Error reading the key file: {e}", file=sys.stderr)
        raise

def main():
    """
    Example usage of load_rsa_key function with error handling.
    """
    try:
        # Try loading the default public key
        print("Attempting to load default public key:")
        default_key = load_rsa_key()
        print("Key contents:")
        print(default_key)
        print("\n--- Key Details ---")
        print(f"Key type: {default_key.split()[0]}")
        print(f"Key length: {len(default_key)} characters")
    
    except FileNotFoundError:
        print("Could not find the default public key.")
        
        # Optional: Try a custom path
        try:
            print("\nAttempting to load key from a custom location:")
            custom_key = load_rsa_key(home_dir="/home/yourusername", key="custom_rsa_key.pub")
            print("Custom key loaded successfully.")
        except Exception as custom_error:
            print(f"Failed to load custom key: {custom_error}")

if __name__ == "__main__":
    main()