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


def get_examples_db_task_id_des_pair(example_json):
    list_of_examples = []
    for t in example_json:
        output_task = {
            "task_id": example_json[t]["task_id"],
            "task_description": example_json[t]["task_description"]
        }
        list_of_examples.append(output_task)
    return list_of_examples


def get_examples_id_task_specification_pair(example_json):
    list_of_examples = []
    for task in example_json:
        print(f"example_json[task]: {example_json[task]}")
        output_task = {
            "task_id": example_json[task]["task_id"],
            "task_description": example_json[task]["task_description"],
            "method_signature": example_json[task]["method_signature"],
            "verifier_methods": example_json[task]["verifier_methods"],
            "input_generators_signature": example_json[task]["input_generators_signature"],
        }
        list_of_examples.append(output_task)
    return list_of_examples
    #  For cwe_examples.json
    # list_of_examples = []
    # for task_id, task_info in example_json.items():
    #     output_task = {
    #         "task_id": task_info["task_id"],
    #         "task_description": task_info["task_description"],
    #         "method_signature": task_info["method_signature"],
    #         "verifier_methods": []
    #     }
    #     print(f"task_info: {task_info}")    
    #     if "verifier_methods" in task_info and isinstance(task_info["verifier_methods"], list):
    #         print(task_info["verifier_methods"])
    #         for method in task_info["verifier_methods"]:
    #             output_task["verifier_methods"].append({
    #                 "method_signature": method["method_signature"],
    #                 "method_description": method["method_description"]
    #             })
    #     list_of_examples.append(output_task)
    # return list_of_examples

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
    post_condition = "\n".join(response.split("\n")[3:])
    task['method_signature'] = signature.strip()
    task['postconditions'] = post_condition.strip()
    return task
