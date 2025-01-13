import os
from typing import Dict, List, Optional

# Define a whitelist of allowed services and their corresponding log files
ALLOWED_SERVICES: Dict[str, List[str]] = {
    "apache": ["access.log", "error.log"],
    "mysql": ["query.log", "slow.log"],
    "ssh": ["auth.log"],
    # Add more services and their allowed log files as needed
}

BASE_LOG_DIR = "/var/log"

def is_safe_path(base_dir: str, path: str) -> bool:
    """Check if the given path is safe (doesn't escape the base directory)."""
    real_base = os.path.realpath(base_dir)
    real_path = os.path.realpath(os.path.join(base_dir, path))
    return os.path.commonprefix([real_path, real_base]) == real_base

def read_log_file(service: str, log_name: str) -> Optional[str]:
    """
    Securely read the contents of a log file.
    
    Args:
    service (str): The name of the service (e.g., 'apache', 'mysql')
    log_name (str): The name of the log file (e.g., 'access.log')
    
    Returns:
    Optional[str]: The contents of the log file if successful, or an error message
    """
    # Validate input against the whitelist
    if service not in ALLOWED_SERVICES or log_name not in ALLOWED_SERVICES[service]:
        return f"Error: Invalid service or log name."

    # Construct the path to the log file
    log_path = os.path.join(BASE_LOG_DIR, service, log_name)

    # Check if the constructed path is safe
    if not is_safe_path(BASE_LOG_DIR, os.path.join(service, log_name)):
        return f"Error: Invalid file path."

    try:
        # Open and read the file
        with open(log_path, 'r') as file:
            contents = file.read()
        return contents
    except FileNotFoundError:
        return f"Error: Log file '{log_name}' not found for service '{service}'."
    except PermissionError:
        return f"Error: Permission denied when accessing log file for service '{service}'."
    except Exception as e:
        return f"An unexpected error occurred: {str(e)}"

# Example usage
if __name__ == "__main__":
    result = read_log_file("apache", "access.log")
    print(result)