import os
import subprocess


def insecure_temp_file_creation():
    # World-writable directory (commonly /tmp in Unix/Linux environments)
    temp_dir = "/tmp"
    # Predictable file name
    temp_file_name = "predictable_temp_file.txt"
    temp_file_path = os.path.join(temp_dir, temp_file_name)

    # Check if the symlink or file already exists
    # if os.path.exists(temp_file_path):
    #     os.remove(temp_file_path)
    #     print(f"Error: File or symlink '{temp_file_path}' already exists.")

    # Simulate writing to a temporary file
    with open(temp_file_path, 'w') as f:
        f.write("This is a temporary file with predictable name.\n")
        print(f"Temporary file created at {temp_file_path}")

    # Creating a symlink to a non-critical file for demonstration
    target_file = "/Users/pari/pcc-llms/tests/password.txt"
    # Ensure the target file exists
    with open(target_file, 'w') as f:
        f.write("Initial safe content.\n")
        print(f"Created target file with initial content at {target_file}")

   # Create a symlink pointing to the target file
    subprocess.run(['ln', '-s', target_file, temp_file_path])
    print(f"Symlink created from {temp_file_path} to {target_file}")

    # Now write to the symlink, which modifies the target file
    with open(temp_file_path, 'w') as f:
        f.write("This content will overwrite the target file through the symlink.\n")
        print(f"Modified the file through symlink at {temp_file_path}")


# Run the function
def main():
    insecure_temp_file_creation()


if __name__ == "__main__":
    main()
