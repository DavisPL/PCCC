import json
import openai
import os
import sys

def load_config(config_path):
    """
    Load configuration from a JSON file.
    """
    try:
        with open(config_path, 'r') as f:
            config = json.load(f)
        required_keys = ['model_name', 'api_key']
        for key in required_keys:
            if key not in config:
                raise KeyError(f"Missing '{key}' in configuration file.")
        return config
    except FileNotFoundError:
        print(f"Configuration file '{config_path}' not found.")
        sys.exit(1)
    except json.JSONDecodeError:
        print(f"Configuration file '{config_path}' is not valid JSON.")
        sys.exit(1)
    except KeyError as e:
        print(e)
        sys.exit(1)

def load_template(template_path):
    """
    Load task template from a text file.
    """
    try:
        with open(template_path, 'r') as f:
            template = f.read()
        return template
    except FileNotFoundError:
        print(f"Template file '{template_path}' not found.")
        sys.exit(1)

def generate_code(config, task_description):
    """
    Send the task description to the LLM API and retrieve the generated code.
    """
    openai.api_key = config['api_key']
    
    try:
        response = openai.ChatCompletion.create(
            model=config['model_name'],
            messages=[
                {"role": "system", "content": "You are an expert Python developer."},
                {"role": "user", "content": task_description}
            ],
            temperature=0,  # Set to 0 for more deterministic output
            max_tokens=1500,  # Adjust based on expected code length
            n=1,
            stop=None
        )
        code = response['choices'][0]['message']['content'].strip()
        return code
    except openai.error.OpenAIError as e:
        print(f"An error occurred while communicating with the OpenAI API: {e}")
        sys.exit(1)

def save_code(code, output_path):
    """
    Save the generated code to a file.
    """
    try:
        with open(output_path, 'w') as f:
            f.write(code)
        print(f"Generated code saved to '{output_path}'.")
    except IOError as e:
        print(f"Failed to write code to '{output_path}': {e}")
        sys.exit(1)

def main():
    # Define paths
    config_path = 'config.json'
    template_path = 'task_template.txt'
    output_path = 'generated_code.py'

    # Load configuration and template
    config = load_config(config_path)
    task_description = load_template(template_path)

    # Generate code using the LLM
    print("Generating code, please wait...")
    code = generate_code(config, task_description)

    # Optional: Print the generated code
    print("\n=== Generated Code ===\n")
    print(code)
    print("\n======================\n")

    # Save the generated code to a file
    save_code(code, output_path)

if __name__ == "__main__":
    main()
