import json
import os


def load_config(home_dir="~", file_path="config.json"):
    """
    Loads a JSON configuration file from the user's home directory.

    Parameters:
        home_dir (str): The path to the home directory. Default is "~".
        file_path (str): The name or relative path of the configuration file. Default is "config.json".

    Returns:
        dict: The parsed JSON configuration as a dictionary.
    """
    # Expand the user's home directory (e.g., "~" becomes "/home/username")
    expanded_home = os.path.expanduser(home_dir)
    
    # Construct the full path to the configuration file
    full_path = os.path.join(expanded_home, file_path)
    
    # Open and parse the JSON configuration file
    with open(full_path, "r") as config_file:
        config = json.load(config_file)
        
    return config

if __name__ == "__main__":
    config = load_config()
    print(f"Configuration: {config}")
