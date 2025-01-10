import sys
from pathlib import Path


def read_file(file_path):
    try:
        with open(Path(file_path).resolve(), "r") as file:
            return file.read()
    except FileNotFoundError:
        print(f"File not found: {file_path}")
        return None

def main(args):
    base_dir = Path(__file__).parent.resolve()
    print(f"Current file directory: {base_dir}")
    print(f"Arguments passed: {args}")
    if len(args) < 1:
        print("Please provide a file path as argument" + " " + str(len(args)))
        return 0
    else:
        file_path = args[0]
        joined_path = base_dir / Path(file_path)
        print(f"Reading file: {joined_path}")
        file_content = read_file(Path(joined_path))
        print(f"File content: {file_content}")
        return 1

if __name__ == "__main__":
    main(sys.argv[1:]) 
    # for instance ../unsafe.txt to access a file outside the current directory cause an error