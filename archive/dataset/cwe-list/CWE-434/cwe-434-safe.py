import os


def save_uploaded_file(file_content, filename):
    allowed_extensions = ['.jpg', '.png', '.txt']
    _, ext = os.path.splitext(filename)

    if ext.lower() not in allowed_extensions:
        raise ValueError("Invalid file type.")

    safe_filename = os.path.basename(filename)
    upload_path = os.path.join('/var/www/uploads/', safe_filename)

    with open(upload_path, 'wb') as f:
        f.write(file_content)

