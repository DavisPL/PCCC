import os
import sys
from pathlib import Path


def write_content_to_file(file_path: str, content: str) -> None:
    print(f"Writing content to file: {file_path}")
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

def main(args):
    base_dir = Path(__file__).parent.resolve()
    print(f"Current file directory: {base_dir}")
    print(f"Arguments passed: {args}")
    if len(args) < 1:
        print("Please provide a file path as argument" + " " + str(len(args)))
        return 0
    else:
        file_path = args[0]
        content = args[1]
        joined_path = base_dir / Path(file_path)
        print(f"Path to file: {joined_path}")
        print(f"Content to write: {content}")
        write_content_to_file(Path(joined_path), content)
        return 1

if __name__ == "__main__":
    main(sys.argv[1:]) 
    # CWE-24 is relative path traversal 
    # for instance ../../another-unsafe.txt to access a file outside the current directory cause an error