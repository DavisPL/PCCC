import openai

class LlmCore:
    def __init__(self):
        pass
    
    def get_api_key(self, api_key):
        openai.api_key = open(api_key, "r").read().strip('\n')
        
    def get_prompt(self, prompt_path):
        
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
    

    def request_code(self, prompt, generated_code_file):
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
        
        with open(generated_code_file, "w") as file:
            file.write(code)

        return code


