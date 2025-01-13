import os
import zipfile


def secure_extract_zip(zip_path, extract_to):
    with zipfile.ZipFile(zip_path, 'r') as zip_ref:
        for member in zip_ref.namelist():
            # Construct the full path for extraction
            full_path = os.path.join(extract_to, member)
            
            # Validate that the path is within the intended extraction directory
            if not os.path.abspath(full_path).startswith(os.path.abspath(extract_to)):
                print(f"Skipped unsafe path: {member}")
                continue  # Skip the file
            
            # Extract the file securely
            os.makedirs(os.path.dirname(full_path), exist_ok=True)
            with open(full_path, 'wb') as f:
                f.write(zip_ref.read(member))