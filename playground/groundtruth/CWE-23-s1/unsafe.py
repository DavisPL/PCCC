import os
import zipfile


def extract_zip(zip_path, extract_to):
    with zipfile.ZipFile(zip_path, 'r') as zip_ref:
        for member in zip_ref.namelist():
            # Attempted Zip Slip prevention - flawed implementation
            safe_member = member.replace('../', '').replace('..\\', '')  # Not recursive
            
            # Construct the full path for extraction
            full_path = os.path.join(extract_to, safe_member)
            
            # Check for unintended directory traversal (not comprehensive)
            if not os.path.abspath(full_path).startswith(os.path.abspath(extract_to)):
                print(f"Potential directory traversal detected: {safe_member}")
                continue  # Skip the file
            
            # Extract the file
            os.makedirs(os.path.dirname(full_path), exist_ok=True)
            with open(full_path, 'wb') as f:
                f.write(zip_ref.read(member))

# Usage example (Assuming 'example.zip' contains malicious paths like '....//....//evil.txt')
# extract_zip('example.zip', '/safe/directory')