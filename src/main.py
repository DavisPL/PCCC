import sys
import argparse
from components import validator
def main(api_key_path, prompt, generated_file_path):
    print("Proof Carrying LLMs")
    print("You are working with the validator!")
    code_validator = validator.Validator()
    code_validator.request_and_validate_code(api_key_path, prompt, generated_file_path)
    
if __name__ == '__main__':
    parser = argparse.ArgumentParser(prog='PCC-LLM', 
                                     description="This program get your APi Key for the\
                                         desire large language model, get the prompt\
                                         and a path for the generated code and\
                                         generates the code with its proof")
    parser.add_argument("api_key_path", help="The file name and path of the API key file")
    parser.add_argument("prompt", help="The prompt file name and path")
    parser.add_argument("generated_file_path", help="The file name and path to save the generated code file")
    
    args = parser.parse_args()
    print(f"args.api_key_path, {args.api_key_path}")
    print(f"args.prompt, {args.prompt}")
    print(f"args.generated_file_path, {args.generated_file_path}")
    sys.exit(main(args.api_key_path, args.prompt, args.generated_file_path))  