"""
Validates the compilation of generated code in a loop

Returns
-------
Path to the file of generated code by LLM
"""

import re
import subprocess
import time
import typing
from subprocess import CalledProcessError, TimeoutExpired, check_output

from components import core as llm_core


class Validator:
    safety_property = None
    generated_code = None
    required_files = None

    def __init__(self):
        print("Validator is running!")

    # Add validator for dafny
    def compile_code(self, generated_code_file, compiler):
        try:
            compile_ouput = subprocess.run(
                [compiler, generated_code_file],
                check=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                timeout=300
            )
        except TimeoutExpired as e:
            compile_ouput = e.stdout.decode("utf-8")
            return -1, -1,  compile_ouput # -1, -1, time_out errors
        except CalledProcessError as e:
            compile_ouput = e.stdout.decode("utf-8")
            if "parse errors detected" in compile_ouput:
                return -2, -2, compile_ouput  # -2, -2, parser_errors
            
        lines = compile_ouput.strip().split("\n")
        last_line = lines[len(lines) - 1]
        if "verifier finished with" in last_line:
            errors = last_line.split(",")[1].strip().split(" ")[0]
            verification = last_line.split(",")[0].strip().split(" ")[5]
            return int(verification), int(errors), compile_ouput
        else:
            return -3, -3, compile_ouput  # -3,-3 type resolution or other errors

    def extract_errors(self, error_message):
        # Pattern to match "Error:" and capture the error type and content
        error_pattern = r'Error:?\s*(.*?)(?=\n\s*Error|\Z)'
        
        # Find all matches for the error pattern
        error_matches = re.finditer(error_pattern, error_message, re.DOTALL)
        
        # Extract and process the matched content
        error_results = []
        for match in error_matches:
            error_full = match.group(1).strip()
            
            # Try to separate error type from the rest of the content
            error_parts = error_full.split('\n', 1)
            if len(error_parts) > 1:
                error_type = error_parts[0].strip()
                error_content = error_parts[1].strip()
            else:
                error_type = "Unknown error type"
                error_content = error_full
            
            # Extract line number from the error content
            line_match = re.search(r'^(\d+)', error_content, re.MULTILINE)
            if line_match:
                line_number = line_match.group(1)
                # Extract the actual content (code line) from the error message
                content_match = re.search(r'^\d+\s*\|\s*(.*)', error_content, re.MULTILINE)
                if content_match:
                    content = content_match.group(1).strip()
                else:
                    content = "Content not found"
            else:
                line_number = "Unknown"
                content = error_content
            
            error_results.append((error_type, line_number, content))
        
        return error_results


    def add_comment_to_line(self, line, comment, code):
        # Convert the line number string to an integer
        # Attaches any exceptions to the related line
        # Returns the modified code with the comment added
        try:
            err_line = int(line)
        except ValueError:
            print(f"Unable to convert the line number string to an integer\n, {ValueError}")


        # Split the text into lines
        lines = code.split('\n')
        # Insert the comment at the specified line number
        lines[err_line - 1] += "  # " + comment  # Adjust for 0-based index
        # Join the lines back together
        modified_text = '\n'.join(lines)
        return modified_text

    def validate_code(
        # Get the prompt, generated code file path, and the number of attempts
        # prompt: str, generated_code_fil e: str, attempts: int, api_config: dict, env_config: dict
        # Return the safety property, code, and required files
        # self, attempts: int, prompt_path: str, output_path: str, api_config: dict, env_config: dict,
       self, error_message, parsed_code
        
    ):
     
        # code_instrument = utils.CodeInstrument()

        # prompt = llm_core.get_prompt(prompt_path).pop()

        # for _ in range(int(attempts)):
        #     llm_response = llm_core.execute_prompt(
        #         api_config, env_config, prompt, output_path)
        #     compiler_type = llm_response["programming_language"]
        # compiler_type = "Dafny"
        # error_message = self.compile_code(output_path, compiler_type)
        # if error_message is None:
        #         return llm_response["safety_property"], llm_response["code"], llm_response["required_files"]
        #     else:
                # Find the line number and error message
        error_components = self.extract_errors(error_message)
        print(f"Error components: {error_components}")
        #         # Get the code from the response
        # modified_code = llm_response['code']
        #         # Add comments to the lines where the errors occur
        if len(error_components) > 0:
            for i, (error_type, line_number, content) in enumerate(error_components, 1):
                print(f"Error {i}: {error_type} \n")
                print(f"Line: {line_number} \n")
                print(f"Content: {content} \n")
                combined_error = f"{error_type}: {content}"
            #             # Add a comment to the line where the error occurs
                modified_code = self.add_comment_to_line(line_number, combined_error, parsed_code)
           
            return modified_code
        else:
            return parsed_code
        #         # Add the error message to the modified prompt
        #         modified_prompt = f"{modified_code} \n\n Compiler Error:\n{error_message}"
        #         llm_core.prompt_ammendment("user", modified_prompt)
        #         # Replaces the modified prompt with a prompt that each error is attached to the related line
        #         # TODO: Use utils instrument class here
        #         # Adds a delay to avoid hitting the API rate limit too quickly
        #         time.sleep(int(env_config['cool_down_time']))
        # raise ValueError(
        #     f"Compilation of the generated code after {attempts} attempts was not successful!")
