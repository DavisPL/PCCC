import os
import tempfile


def process_sensitive_data(data):
    # Create a temporary file with default permissions
    temp_file = tempfile.NamedTemporaryFile(mode='w+t', delete=False) # Add a temp txt file
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