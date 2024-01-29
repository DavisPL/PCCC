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
        print(f"compiler {compiler}")
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
            if error_message is not None:
                modified_prompt = f"{prompt}\n\n \n\n{llm_response['code']} \n\n Compiler Error:\n{error_message}"
                llm_core.prompt_ammendment("user", modified_prompt)
                # import pdb; pdb.set_trace()
                # llm_core.messages
                #TO DO: Replace the modified prompt with a prompt that each error is attached to the related line
                #Use utils nstrument class here
                time.sleep(
                    5
                )  # Adds a delay to avoid hitting the API rate limit too quickly
        return llm_response["safety_property"], llm_response["code"], llm_response["required_files"]
            
                # code_lines = code_instrument.count_lines()
                # import pdb; pdb.set_trace()
            # try:
            #     llm_response["code"] 
            #     compiler_type = llm_response["programming_language"]
                # error_message = self.compile_code(
                #     generated_code_file, compiler_type)
            #     llm_core.prompt_ammendment("system", error_message)
            #     llm_core.message_history.append
            #     llm_core.prompt_ammendment("system", error_message)
            #     llm_core.message_history.append
            # except TypeError as e:
            #     print(e)
                
            # except ValueError as e:
            #     print(e)
                
            # else:
            #     print("Code does not exist!")
            
               
                # try:
                #     assert code is not None
                #     print(f"Received code:\n{code}")
                #     error_message = self.compile_code(generated_code_file, compiler_type)
                #     print("error_message")
                # except AssertionError as msg:
                #     print(msg)

                # try:
                #     assert error_message is None
                #     return safety_property, code, req_files
                # except AssertionError as msg:
                #     print(msg)
                #     new_prompt = f"{prompt}\n\n \n\n{code} \n\n Compiler Error:\n{error_message}"
                #     time.sleep(
                #         5
                #     )  # Adds a delay to avoid hitting the API rate limit too quickly
                #     with open(prompt_path, "w", encoding='utf-8') as f:
                #         f.write(f"{new_prompt}")
                # if llm_response["code"] is not None:
                #     compiler_type = llm_response["programming_language"]
                #     error_message = self.compile_code(
                #         generated_code_file, compiler_type)
                #     llm_core.prompt_ammendment("system", error_message)
                #     llm_core.message_history.append
                #     if error_message is None:
                        # return safety_property, code, req_files
                # else:
                #     print("Failed to extract code from response. \n")

                # print("Attempting to compile the code... \n")
                # # error_message = self.compile_rust_code(generated_code_file)

                # if error_message is None and code is not None:
                #     print("Compilation succeeded! \n")
                #     return safety_property, code, req_files
                # else:
                #     print(f"Compilation failed with error:\n{error_message}")
                #     # Modify the prompt with the error message to get a better response
                #     new_prompt = f"{prompt}\n\n \n\n{code} \n\n Compiler Error:\n{error_message}"
                #     time.sleep(
                #         5
                #     )  # Adds a delay to avoid hitting the API rate limit too quickly
                #     with open(prompt_path, "w", encoding='utf-8') as f:
                #         f.write(f"{new_prompt}")
