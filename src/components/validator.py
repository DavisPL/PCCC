"""
Validates the compilation of generated code in a loop

Returns
-------
Path to the file of generated code by LLM
"""

import re
import subprocess
import time
import traceback

from components import core, vc_generator
from utils import utils


class Validator:
    safety_property = None
    generated_code = None
    required_files = None
    def __init__(self):
        print("Validator is running!")

    # Add validator for dafny
    def compile_code(self, generated_code_file, compiler):
        print(f"Compiler {compiler}")
        try:
            subprocess.run(
                [compiler, generated_code_file],
                check=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
            )
            
            return None
        except subprocess.CalledProcessError as e:
            output = e.stdout.decode("utf-8")
            print("Had error", output)
            return output

    def find_match (self, error):
        # Pattern to find the line that error occurs and the corresponding error
        pattern = r'\(([^),]+),[^)]*\):\s*Error:(.+)'

        # Finding matches
        matches = re.findall(pattern, error)
        print(f"matches {matches}")
        error_res = [(match[0], match[1].strip()) for match in matches]
        for line, message in error_res:
            return line, message
            
    def add_comment_to_line(self, line_number, comment, code):
        try:
            err_line = int(line_number)
        except ValueError:
            print("Unable to convert the line number string to an integer.")
            
        # Split the text into lines
        lines = code.split('\n')
        # Insert the comment at the specified line number
        lines[err_line - 1] += "  # " + comment  # Adjust for 0-based index
        # # Join the lines back together
        modified_text = '\n'.join(lines)
        return modified_text
        
    def validate_code(
        self, attempts, prompt_path, generated_code_file
    ):
        llm_core = core.LLMCore()
        # code_instrument = utils.CodeInstrument()
        
        prompt = llm_core.get_prompt(prompt_path).pop()
    
        for _ in range(attempts):
            # for prompt in prompts:
            llm_response = llm_core.request_code(
                prompt, generated_code_file)
            
            print(f"programming_language ----- ", llm_response["programming_language"])
            compiler_type = llm_response["programming_language"]
            error_message = self.compile_code(generated_code_file, compiler_type)
            
            if error_message is None:
                return llm_response["safety_property"], llm_response["code"], llm_response["required_files"]
            else:
                line, error = self.find_match(error_message)
                modified_code = self.add_comment_to_line(line, error, llm_response['code'])
                modified_prompt = f"{prompt}\n\n \n\n{modified_code} \n\n Compiler Error:\n{error_message}"
                llm_core.prompt_ammendment("user", modified_prompt)
                print(f"modified prompt", modified_prompt)
                #TODO: Replace the modified prompt with a prompt that each error is attached to the related line
                ##TODO: Use utils instrument class here
                time.sleep(
                    5
                )  # Adds a delay to avoid hitting the API rate limit too quickly
        raise Exception(f"Compilation of the generated code after {attempts} attempts was not successful!")