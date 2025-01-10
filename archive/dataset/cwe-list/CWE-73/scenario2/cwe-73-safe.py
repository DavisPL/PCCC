import os


def delete_file():
    filename = input("Enter the filename to delete: ")
    base_dir = '/tmp/'
    safe_filename = os.path.normpath(os.path.join(base_dir, filename))

    # Prevent external control
    if not safe_filename.startswith(os.path.abspath(base_dir)):
        raise ValueError("Invalid filename")

    os.remove(safe_filename)

delete_file()
