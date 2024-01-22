"""
Validates the compilation of generated code in a loop

Returns
-------
Path to the file of generated code by LLM
"""
import subprocess
import time

from components import core, vc_generator


class Validator:
    def __init__(self):
        print("Validator is running!")

    # Add validator for dafny
    def compile_code(self, generated_code_file, compiler: str):
        print(f"compiler {compiler}")
        try:
            subprocess.run(
                [compiler, generated_code_file],
                check=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                ## TO DO: Handle Dafny compiler errors
                # stderr=subprocess.STDOUT,
            )
            print(subprocess.STDOUT)
            return None
        except subprocess.CalledProcessError as e:
            exit_code = e.returncode
            stderror = e.stderr
            print(f"exit_code {exit_code}")
            print(f"stderror {stderror}")
            return e.stderr

    def request_and_validate_code(
        self, attempts, prompt_path, generated_code_file
    ):
        llm_core = core.LLMCore()
        llm_core.get_api_key()
        prompts = llm_core.get_prompt(prompt_path)
        safety_property = None
        for _ in range(attempts):
            for prompt in prompts:
                code, compiler_type, safety_property, req_files = llm_core.request_code(prompt, generated_code_file)
                try:
                    assert code is not None
                    print(f"Received code:\n{code}")
                    error_message = self.compile_code(generated_code_file, compiler_type)
                    print("error_message")
                except AssertionError as msg:
                    print(msg)
                
                try:
                    assert error_message is None
                    return safety_property, code, req_files
                except AssertionError as msg:
                    print(msg)
                    new_prompt = f"{prompt}\n\n \n\n{code} \n\n Compiler Error:\n{error_message}"
                    time.sleep(
                        5
                    )  # Adds a delay to avoid hitting the API rate limit too quickly
                    with open(prompt_path, "w", encoding='utf-8') as f:
                        f.write(f"{new_prompt}")
                        
            print("Here ????")
            return None
                # print(f"safety_property {safety_property}")
                # if code is not None:
                #     print(f"Received code:\n{code}")
                #     error_message = self.compile_code(generated_code_file, compiler_type)
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

    