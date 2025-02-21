import os
import sys
from pathlib import Path


def write_content_to_file(file_path: Path, content: str) -> None:
    try:
        with file_path.open('w', encoding='utf-8') as f:
            f.write(content)
        print(f"Successfully wrote to: {file_path}")
    except FileNotFoundError as e:
        print(f"Error: {e}")
    except Exception as e:
        print(f"Error: {e}")

def main(args):
    if len(args) < 2:
        print("Provide a file path and content.")
        return 0

    base_dir = Path(__file__).parent.resolve()
    file_path = (base_dir / args[0]).resolve() 
    content = args[1]

    if not str(file_path).startswith(str(base_dir)):
        print("Invalid file path!")
        return 0

    write_content_to_file(file_path, content)
    return 1

if __name__ == "__main__":
    main(sys.argv[1:])