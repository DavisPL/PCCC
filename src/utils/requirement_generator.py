import json


def load_json_template(file_path):
    """Load the JSON template from a file."""
    with open(file_path, 'r') as file:
        return json.load(file)

def fill_template(template):
    """Recursively fill the JSON template with user input."""
    filled_template = {}
    for key, value in template.items():
        if isinstance(value, dict):  # If value is a nested dictionary, recurse
            print(f"Entering section: {key}")
            filled_template[key] = fill_template(value)
        else:
            user_value = input(f"Enter value for '{key}' (default: {value}): ")
            filled_template[key] = user_value if user_value else value
    return filled_template

def save_filled_json(output_path, data):
    """Save the filled JSON to a file."""
    with open(output_path, 'w') as file:
        json.dump(data, file, indent=4)
    print(f"Updated JSON saved to {output_path}")

def main():
    template_file = input("Enter the template JSON file path: ")
    output_file = input("Enter the output JSON file path: ")
    
    try:
        template = load_json_template(template_file)
        filled_template = fill_template(template)
        save_filled_json(output_file, filled_template)
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    main()