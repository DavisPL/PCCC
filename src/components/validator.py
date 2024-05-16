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

from components import core


class Validator:
    safety_property = None
    generated_code = None
    required_files = None

    def __init__(self):
        print("Validator is running!")

    # Add validator for dafny
    def compile_code(self, generated_code_file, compiler):
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
            return output

    def find_match(self, error):
        # Pattern to find the line that error occurs and the corresponding error
        pattern = r'\(([^),]+),[^)]*\):\s*Error:(.+)'
        # Finding matches for error lines
        matches = re.findall(pattern, error)
        error_res = [(match[0], match[1].strip()) for match in matches]
        return error_res

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
        # prompt: str, generated_code_fil e: str, attempts: int
        # Return the safety property, code, and required files
        self, attempts: int, prompt_path: str, generated_code_file: str
    ):
        llm_core = core.LLMCore()
        # code_instrument = utils.CodeInstrument()

        prompt = llm_core.get_prompt(prompt_path).pop()

        for _ in range(attempts):
            # for prompt in prompts:
            llm_response = llm_core.request_code(
                prompt, generated_code_file)
            compiler_type = llm_response["programming_language"]
            compiler_type = "Dafny"
            error_message = self.compile_code(
                generated_code_file, compiler_type)

            if error_message is None:
                return llm_response["safety_property"], llm_response["code"], llm_response["required_files"]
            else:
                # Find the line number and error message
                errors = self.find_match(error_message)
                # Get the code from the response
                modified_code = llm_response['code']
                # Add comments to the lines where the errors occur
                for line, error in errors:
                    # Add a comment to the line where the error occurs
                    modified_code = self.add_comment_to_line(
                        line, error, modified_code)
                # Add the error message to the modified prompt
                modified_prompt = f"{modified_code} \n\n Compiler Error:\n{error_message}"
                llm_core.prompt_ammendment("user", modified_prompt)
                # Replaces the modified prompt with a prompt that each error is attached to the related line
                # TODO: Use utils instrument class here
                # Adds a delay to avoid hitting the API rate limit too quickly
                time.sleep(
                    5
                )
        raise ValueError(
            f"Compilation of the generated code after {attempts} attempts was not successful!")
