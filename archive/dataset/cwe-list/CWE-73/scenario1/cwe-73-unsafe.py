import os

def read_log_file(service, log_name):
    # Construct the path to the log file
    log_path = os.path.join('/var/log', service, log_name)
    
    try:
        with open(log_path, 'r') as file:
            contents = file.read()
        return contents
    except FileNotFoundError:
        return f"Error: Log file '{log_path}' not found."
    except PermissionError:
        return f"Error: Permission denied when accessing '{log_path}'."
    except Exception as e:
        return f"An unexpected error occurred: {str(e)}"


# Attack1: Simulating attack 1
print("Simulating the attack:")
# username = "../.."  # Go up two directories
# filename = "etc/passwd"  # Try to access the system's password file

# # Now run the vulnerable function
# file_contents = read_log_file(username, filename)
# print(f"File contents: {file_contents}")


# Attack2: Simulating attack 2 by accessing logs from a different service
result = read_log_file("confidential_service", "secret.log")
print(f"File contents: {result}")

# Attack3: Simulating attack 3 by reading arbitrary files
# result = read_log_file("../../../../home/user", ".ssh/id_rsa")
# print(f"File contents: {result}")