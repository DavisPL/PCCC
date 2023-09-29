import subprocess
import time

from components import core

class Validator:
    def __init__(self):
      pass
    
    def compile_rust_code(self, generated_code_file):
        try:
            # Check the Rust code to see if it comiples or not
            subprocess.run(["rustc", generated_code_file], check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            return None  # No error message since compilation succeeded
        except subprocess.CalledProcessError as e:
            return e.stderr.decode() 
        
    def request_and_validate_code(self):
        api_key_file = "src/key.txt"
        llm_core = core.LlmCore()
        llm_core.get_api_key(api_key_file)
        prompt_path = "src/prompt.txt"
        generated_code_file = "src/generated_code.rs"
        prompts = llm_core.get_prompt(prompt_path)
        for _ in range(3):
            for prompt in prompts:
                code = llm_core.request_code(prompt, generated_code_file)
                if code is not None:
                    print(f"Received code:\n{code}")
                else:
                    print("Failed to extract code from GPT-3 response.")
                
                print("Attempting to compile the Rust code...")
                error_message = self.compile_rust_code(generated_code_file)
                if error_message is None:
                    print("Compilation succeeded!")
                    return
                else:
                    print(f"Compilation failed with error:\n{error_message}")
                    # Modify the prompt with the error message to get a better response
                    current_prompt = f"{prompt}\n\nCompiler Error:\n{error_message}"
                    time.sleep(1)  # Add a delay to avoid hitting the API rate limit too quickly
                    with open(prompt_path, 'a') as prompts_file:
                        prompts_file.write(f"\n---\n{current_prompt}")
