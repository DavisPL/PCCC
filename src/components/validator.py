"""
Validates the compilation of generated code in a loop

Returns
-------
Path to the file of generated code by LLM
"""

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
            
            compiler_type = llm_response["programming_language"]
            error_message = self.compile_code(generated_code_file, compiler_type)
            if error_message is None:
                return llm_response["safety_property"], llm_response["code"], llm_response["required_files"]
            else:
                modified_prompt = f"{prompt}\n\n \n\n{llm_response['code']} \n\n Compiler Error:\n{error_message}"
                llm_core.prompt_ammendment("user", modified_prompt)
                #TODO: Replace the modified prompt with a prompt that each error is attached to the related line
                ##TODO: Use utils instrument class here
                time.sleep(
                    5
                )  # Adds a delay to avoid hitting the API rate limit too quickly
        raise Exception(f"Compilation of the generated code after {attempts} attempts was not successful!")