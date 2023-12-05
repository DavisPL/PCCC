"""
Core includes LLM models
Gets prompt from the user 

Returns
-------
_type_
    _description_
"""
import json
import os

import openai
from dotenv import load_dotenv


class LlmCore:
    def __init__(self):
        pass

    # Open the file containing the API key
    def get_api_key(self, api_key_file):
        load_dotenv()
        """Reads api key from file"""
        openai.api_key = os.environ["OPENAI_API_KEY"]
        return openai.api_key

    def get_prompt(self, prompt_path):
        try:
            with open(prompt_path, "r") as file:
                content = file.read()
                prompts = content.split("---\n")
                prompts = [prompt.strip() for prompt in prompts if prompt.strip()]
        except FileNotFoundError:
            ## TODO: Provide a format for prompt and pass it to the function
            print(f"Error: The file {prompt_path} does not exist.")
            prompts = []
        except IOError as e:
            print(f"Error reading the file {prompt_path}: {str(e)}")
            prompts = []
        return prompts

    def request_code(self, prompt, generated_code_file):
        ## TODO Get model specifications from config in the function args
        message_history = []
        responses = []
        # client = O
        try:
            message_history.append(
                # {"role": "system", "content": "You are a helpful code generator tool"},
                {"role": "user", "content": prompt}
            ),
            completion = openai.ChatCompletion.create(
                model="gpt-4",
                messages=message_history,
                max_tokens=4000,  # Adjustable number of tokens to control response length
                n=1,
                stop=None,
                temperature=0.5,
                # response_format={"type": "json_object"},
            )
            try:
                ##TODO Add config file for the model specifications
                # response = completion.choices[0].message.content
                content = completion.choices[0].message.content
                print(f"LLM generated_text {content}")
                response_json = json.loads(content)
                # print(f"LLM responds {response_json}")

                # code_start = response.find("```")
                # code_end = response.rfind("```")

                # if code_start == -1 or code_end == -1 or code_start == code_end:
                #     return None  # Could not find the code in the response

                # code = response[code_start + len("```") : code_end].strip()
                responses.append(content)
                code = response_json["code"]
                print(f"code ??? {code}")
                # code_start = code.find("```")
                # code_end = code.rfind("```")

                # if code_start == -1 or code_end == -1 or code_start == code_end:
                #     return None  # Could not find the code in the response

                # code = code[code_start + len("```") : code_end]
                message_history.append({"role": "assistant", "content": content})
            except openai.error.OpenAIError as e:
                print(f"Error encountered for prompt {str(e)}")

            try:
                with open(generated_code_file, "w", encoding="utf-8") as f:
                    print(f"Code {code}")
                    f.write(code)
                    f.close()
            except FileNotFoundError:
                print(f"Cannot find {generated_code_file}")

            except IOError as e:
                print(f"Error writing into the file {generated_code_file}: {str(e)}")

            return code
        except Exception as e:
            print(f"An error occured in the API: {e}")
            return None
