
# Improper Limitation of a Pathname to a Restricted Directory ('Path Traversal')
import os
import sys

# def main():
#     print(sys.argv, len(sys.argv))
#     filename = sys.argv[1]
#     print(f"Filename {filename}")
#     path = os.path.join(os.getcwd(), filename)
#     print(f"path {path}")
#     try:
#         with open(path, 'r') as f:
#           file_data = f.read()
#           print(f"file_data {file_data}")
#     except FileNotFoundError as e:
#        print("Error - file not found")
  
# ## Safe version 
def main():
    if len(sys.argv) < 2:
        print("Error: Please provide a filename as a command line argument.")
        return

    # Get the provided filename from command line arguments
    filename = sys.argv[1]

    # Resolve the filename to an absolute path
    abs_path = os.path.abspath(filename)

    # Check if the resolved absolute path starts with the current working directory
    if not abs_path.startswith(os.getcwd()):
        print("Error: Invalid filename.")
        return

    print(f"Absolute path: {abs_path}")

    try:
        with open(abs_path, 'r') as f:
            file_data = f.read()
            print(f"File data: {file_data}")
    except FileNotFoundError as e:
        print("Error: File not found")

        
if __name__ == '__main__':
  main()