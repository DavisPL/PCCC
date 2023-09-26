import openai
import subprocess
import time



def get_prompt(prompt_path):
    
    try:
        with open(prompt_path, 'r') as file:
            content = file.read()
            prompts = content.split('---\n')
            prompts = [prompt.strip() for prompt in prompts if prompt.strip()]
    except FileNotFoundError:
        print(f"Error: The file {prompt_path} does not exist.")
        prompts = []
    except IOError as e:
            print(f"Error reading the file {prompt_path}: {str(e)}")
            prompts = []
    return prompts
    

def compile_rust_code(file_name):
    try:
        # Try to compile the Rust code
        subprocess.run(["rustc", file_name], check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        return None  # No error message since compilation succeeded
    except subprocess.CalledProcessError as e:
        return e.stderr.decode() 


def request_code(prompt, file_name):
    message_history = []
    responses = []
    try:
        message_history.append({
        'role': 'system', 
        'content': prompt
        }),
        completion = openai.ChatCompletion.create(
            model="gpt-4",
            messages= message_history,
            max_tokens=4000,  # Adjustable number of tokens to control response length
            n=1,
            stop=None,
            temperature=0.5,
    )
        reply_content = completion.choices[0].message.content
        print(reply_content)
       
        code_start = reply_content.find('```rust')
        code_end = reply_content.rfind('```')
        
        if code_start == -1 or code_end == -1 or code_start == code_end:
            return None  # Could not find the code in the response
    
        code = reply_content[code_start + len('```rust'):code_end].strip()
        responses.append(reply_content)
        message_history.append({'role': 'assistant', 'content': reply_content})
    except openai.error.OpenAIError as e:
        print(f"Error encountered for prompt {str(e)}")
    
    with open(file_name, "w") as file:
        file.write(code)

    return code


def llm_core():
    openai.api_key = open("src/key.txt", "r").read().strip('\n')
    prompt_path = "src/prompt.txt"
    generated_code_name = "src/generated_code.rs"
    prompts = get_prompt(prompt_path)
    for _ in range(3):
        for prompt in prompts:
            code = request_code(prompt, generated_code_name)
            if code is not None:
                print(f"Received code:\n{code}")
            else:
                print("Failed to extract code from GPT-3 response.")
            
            print("Attempting to compile the Rust code...")
            error_message = compile_rust_code(generated_code_name)
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
