"""
Validates the compilation of generated code in a loop

Returns
-------
Path to the file of generated code by LLM
"""
import subprocess
import time

from components import core


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
                # stderr=subprocess.STDOUT,
            )
            return None
        except subprocess.CalledProcessError as e:
            return e.stderr.decode()

    def request_and_validate_code(
        self, attempts, prompt_path, generated_code_file
    ):
        llm_core = core.LLMCore()
        llm_core.get_api_key()
        prompts = llm_core.get_prompt(prompt_path)
        for _ in range(attempts):
            for prompt in prompts:
                code, compiler_type = llm_core.request_code(prompt, generated_code_file)
                if code is not None:
                    print(f"Received code:\n{code}")
                else:
                    print("Failed to extract code from response. \n")

                print("Attempting to compile the code... \n")
                # error_message = self.compile_rust_code(generated_code_file)

                error_message = self.compile_code(generated_code_file, compiler_type)
                if error_message is None:
                    print("Compilation succeeded! \n")
                    return
                else:
                    print(f"Compilation failed with error:\n{error_message}")
                    # Modify the prompt with the error message to get a better response
                    new_prompt = f"{prompt}\n\n \n\n{code} \n\n Compiler Error:\n{error_message}"
                    time.sleep(
                        5
                    )  # Add a delay to avoid hitting the API rate limit too quickly
                    with open(prompt_path, "w") as f:
                        f.write(f"{new_prompt}")

        return generated_code_file