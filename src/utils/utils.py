import json
import os
import re


def read_file(file_path):
    try:
        with open(file_path, "r", encoding='utf-8') as f:
            content = f.read()
            f.close()
            if os.stat(file_path).st_size == 0:
                raise ValueError("Prompt file is empty")
    except FileNotFoundError:
        print(f"Error: The file {file_path} does not exist.")
    except IOError as e:
        print(f"Error reading the file {file_path}: {str(e)}")
    return content

def write_to_file(string, file_path):
    try:
        with open(file_path, "w", encoding='utf-8') as f:
            f.write(string)
            f.close()
    except FileNotFoundError:
        print(f"Error: The file {file_path} does not exist.")
    except IOError as e:
        print(f"Error reading the file {file_path}: {str(e)}")

def append_file(file_path, content):
    with open(file_path, "a", encoding='utf-8') as f:
        f.write(f"\n---\n{content}")
        f.close()

def read_lines(file_path):
    # Read all the lines into a list
    lines = None
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            lines = file.readlines()
    except FileNotFoundError:
        print(f"Error: The file {file_path} does not exist.")
    return lines

def write_lines(file_path, lines):
    try:
        with open(file_path, 'w', encoding='utf-8') as file:
            # Write the modified lines back to the file
            file.writelines(lines)
    except FileNotFoundError:
        print(f"Error: The file {file_path} does not exist.")




def pattern_match(pattern, string):
    match = re.search(pattern, string)
    if match:
        print(
            f"The pattern '{match.group(1)}' was found.")
        return match.group(1)
    else:
        print("No match found.")
    return None


def parse_data_to_dict(data):
    # Initialize an empty dictionary to store the data
    parsed_data = {}

    # Split the data by lines to process each line separately
    lines = data.strip().split('\n')

    # Variables to keep track of the current section we are parsing
    current_section = None

    for line in lines:
        line = line.strip()
        if line.endswith(':'):
            # This is a section title
            current_section = line[:-1]  # Remove the colon and set as current section
            parsed_data[current_section] = []
        else:
            # This is content under the current section
            if current_section:
                parsed_data[current_section].append(line)

    # Post-process to turn list into a single string if it makes sense
    for key, value in parsed_data.items():
        if len(value) == 1:
            parsed_data[key] = value[0]

    return parsed_data

def extract_task_specifications(example_tasks):
    """Extracts task specifications from example tasks.

    Args:
        example_tasks (Dict[str, Dict[str, Any]]): A dictionary of example tasks.

    Returns:
        List[Dict[str, Any]]: A list of task specifications.
    """
    task_specifications = []
    for task_id, task_data in example_tasks.items():
        task_spec = {
            "task_id": task_data['task_id'],
            "task_description": task_data['task_description'],
            "method_signature": task_data['method_signature'],
            "api_with_preconditions": task_data['api_with_preconditions'],
        }
        task_specifications.append(task_spec)
    return task_specifications

def format_api_reference(api_ref):
    formatted_ref = ""
    for method in api_ref.values():
        formatted_ref += f"{method['method_signature']}\n"
        preconditions = method['preconditions'].split('\n')
        formatted_ref += '\n'.join(precond.strip() for precond in preconditions if precond.strip())
        formatted_ref += "\n\n"
    
    # Remove the last newline
    formatted_ref = formatted_ref.rstrip()
    
    # Create a JSON object with a single "api_reference" key
    json_output = json.dumps({"api_reference": formatted_ref})
    
    return json_output


def save_to_json(map, file_path):
    json_string = json.dumps(map)
    with open(file_path, "w") as text_file:
        text_file.write(json_string)


def load_json(file_path):
    with open(file_path, 'r') as file:
        tasks = json.load(file)
    return tasks

def parse_specification_response(task, response):
    signature = response.split("\n")[1]
    safety_properties = "\n".join(response.split("\n")[3:])
    task['method_signature'] = signature.strip()
    task['safety_properties'] = safety_properties.strip()
    return task

    
def prepend_include_to_code(response, interface_path): 
    # Use regex to find Dafny code blocks
    pattern = r'```dafny\n(.*?)```'
    dafny_blocks = re.findall(pattern, response, re.DOTALL)
    for block in dafny_blocks:
        modified_block = f'include "{interface_path}"\n\n{block.strip()}'  
        response = response.replace(f'```dafny\n{block}```', 
                                                      f'```dafny\n{modified_block}\n```')
        
    return response
