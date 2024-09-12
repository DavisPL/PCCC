import json
import os
import sys


def read_file(file_path):
    try:
        with open(file_path, 'r') as file:
            return file.read()
    except IOError as e:
        print(f"Error reading file: {e}")
        sys.exit(1)

def process_code(content):
    lines = content.split('\n')
    code_lines = [line for line in lines if not line.strip().startswith('include')]
    return '\n'.join(code_lines)

def convert_code_to_json(code):
    # Remove leading and trailing whitespace
    code = code.strip()
    
    # Replace double quotes
    code_escaped = code.replace('"', '\"')
    
    # Replace newlines with '\n'
    code = code_escaped.replace('\n', '\n' + ' ')
    
    # Create the JSON object
    json_obj = {
        "code": code
    }
    
    # Convert to JSON string
    return json.dumps(json_obj, ensure_ascii=False, indent=2)

def save_json_to_file(json_output, output_file_path):
    try:
        with open(output_file_path, 'w') as file:
            file.write(json_output)
        print(f"JSON output saved to: {output_file_path}")
    except IOError as e:
        print(f"Error writing to file: {e}")
        sys.exit(1)

def main():
    if len(sys.argv) != 2:
        print("Usage: python script.py <input_file_path>")
        sys.exit(1)

    input_file_path = sys.argv[1]
    lines = read_file(input_file_path)
    code = process_code(lines)
    json_output = convert_code_to_json(code)
    
    # Generate output file name in the same directory as the input file
    input_dir = os.path.dirname(input_file_path)
    print(f"{os.path.abspath(input_file_path)}")
    input_file_name = os.path.basename(os.path.abspath(input_file_path))
    print(f"Input file name: {input_file_name}")
    output_file_name = os.path.splitext(input_file_name)[0] + "_output.json"
    print(f"Output file name: {output_file_name}")
    output_file_path = os.path.join(os.path.abspath(os.path.dirname(input_dir)), output_file_name)
    print(f"Output file path: {output_file_path}")
    save_json_to_file(json_output, output_file_path)


if __name__ == "__main__":
    main()
    
