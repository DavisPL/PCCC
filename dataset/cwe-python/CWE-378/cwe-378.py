import os
import tempfile


def process_sensitive_data(data):
    # Create a temporary file with default permissions
    temp_file = tempfile.NamedTemporaryFile(mode='w+t', delete=False)
    temp_file.write(data)
    temp_file.close()
    
    # Process the data
    with open(temp_file.name, 'r') as file:
        processed_data = file.read().upper()
    
    # Clean up
    os.unlink(temp_file.name)
    
    return processed_data

# Usage
sensitive_info = "password123"
result = process_sensitive_data(sensitive_info)

# A program that creates a temporary file to store sensitive data 
# The temporary file is created with default permissions, which might be 
# too permissive and allow other users on the system to read the sensitive data

# --------- Safe version ---------
# import tempfile
# import os

# def process_sensitive_data(data):
#     # Create a temporary file with restricted permissions
#     temp_fd, temp_path = tempfile.mkstemp(text=True)
#     os.close(temp_fd)
    
#     try:
#         # Set restrictive permissions
#         os.chmod(temp_path, 0o600)
        
#         with open(temp_path, 'w+t') as temp_file:
#             temp_file.write(data)
#             temp_file.seek(0)
#             processed_data = temp_file.read().upper()
    
#     finally:
#         # Clean up
#         os.unlink(temp_path)
    
#     return processed_data

# # Usage
# sensitive_info = "password123"
# result = process_sensitive_data(sensitive_info)