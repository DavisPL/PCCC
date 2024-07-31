import json
import os


def read_code_from_file(file_path):
    with open(file_path, 'r') as file:
        return file.read()

def generate_json(task_id, task_description, method_signature, api_with_preconditions, code_file_path, output_path):
    # Read the code snippet from the file
    code_snippet = read_code_from_file(code_file_path)
    
    # Create a dictionary with the provided key-value pairs
    data = {
        "task_id": task_id,
        "task_description": task_description,
        "method_signature": method_signature,
        "api_with_preconditions": api_with_preconditions,
        "code": json.dumps(code_snippet)  # Convert code snippet to JSON-compatible string
    }
    
    # Create the directory if it doesn't exist
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    
    # Write the JSON data to the specified file
    with open(output_path, 'w') as json_file:
        json.dump(data, json_file, indent=2)
    
    print(f"JSON file has been successfully generated and saved to: {output_path}")

def main():
    task_id = "5"
    task_description = ""
    method_sig = "method LoadUserData(path: seq<char>, userName: string) returns (data: array<byte>)"
    api_precond = ""
    code_file = "/Users/pari/pcc-llms/dataset/cwe-samples/RAG_samples/task_id_5.dfy"
    output_file = "/Users/pari/pcc-llms/dataset/cwe-samples/RAG_samples_json/task_id_5.json"
    generate_json(task_id, task_description, method_sig, api_precond, code_file, output_file)
    
# Example usage
if __name__ == "__main__":
    main()
    
