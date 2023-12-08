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
from dotenv import find_dotenv, load_dotenv
from openai import OpenAI


class LLMCore:
    def __init__(self):
        self.client = OpenAI(api_key = "")
        # self.function = {
        #     "name": "json_format_composer",
        #     "description": "A function that takes in a list of arguments related to a \
        #         generated code and format it in json",
        #     "parameters": {
        #         "code_description": {
        #             "type": "string",
        #             "description": "Information about the code"
        #         },
        #         "code": {
        #             "type": "string",
        #             "description": "A code generated based on the provided explaination for its functionality"
        #         },
        #         "code_specs": {
        #             "type": "array",
        #             "description": "A list of code specifications",
        #             "items": {
        #                 "programming_language": {
        #                     "type": "string",
        #                     "description": "A programming language the code is written in"
        #                 },
        #                 "provided_libraries": {
        #                     "type": "array",
        #                     "description": "A list of libraries provided to the code",
        #                     "items": {
        #                         "library_name": {
        #                             "type": "string",
        #                             "description": "Name of the library"
        #                         },
        #                         "library_application": {
        #                             "type": "string",
        #                             "description": "A description of how to use the library"
        #                         }
        #                     }
        #                 },
        #                 "safety_properties": {
        #                     "type": "array",
        #                     "description": "A programming language the code is written in",
        #                     "items": {
        #                         "specification_id": {
        #                             "type": "string",
        #                             "description": "ID of the specification"
        #                         },
        #                         "specification_type": {
        #                             "type": "string",
        #                             "description": "Defines type of the specificaion\
        #                                 (precondition, postcondition, assert)"
        #                         }
        #                     }
        #                 },
                        
        #             }
        #         }
        #     },
        #     "required": {"code_description", "code", "code_specs"},
        # }
        # self.sample_response = openai.openai_object.OpenAIObject()
        
    # def get_sample_response(self, sample):
    #     self.sample_response["role"] = 
    # def get_json_format(self, function):
    #     if function:
    #         self.function = function
    # Open the file containing the API key
    def get_api_key(self):
        try:
            load_dotenv()
            """Reads api key from file"""
            print(f"Succesfully read OpenAI API key")
            self.client.api_key = os.environ["OPENAI_API_KEY"]
        except Exception as e: 
            print(f"OpenAI API key has not been set properly and returns this error {e}")

        return self.client.api_key

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
        message_history.append(
            # {"role": "system", "content": "You are a helpful code generator tool"},
            {"role": "user", "content": prompt, }
        )
        completion = self.client.chat.completions.create(
            model="gpt-4",
            messages=message_history,
            max_tokens=4000,  # Adjustable number of tokens to control response length
            n=1,
            stop=None,
            temperature=0.5,
            # functions=[self.function],
            # function_call={"name": "json_format_composer"}
            # response_format={"type": "json_object"},
        )
        try:
            ##TODO Add config file for the model specifications
            ##TODO: Add function calling to api for a more structured json format with few shot learning
            response = completion.choices[0].message.content
            # response = completion.choices[0].message.function_call.arguments
            response_json = json.loads(response)
            print(f"Generated response {response_json}")
            content_json = json.loads(response)
            code = content_json.get("code")
            programming_language = content_json.get("programming_language")
            print(f"programming_language \n {programming_language}")
            responses.append(response)
            message_history.append({"role": "assistant", "content": response})

            try:
                with open(generated_code_file, "w") as f:
                    print(f"Code in JSON format: \n ------------------ \n {code}")
                    f.write(code)
                    f.close()
            except FileNotFoundError:
                print(f"Cannot find {generated_code_file}")

            except IOError as e:
                print(f"Error writing into the file {generated_code_file}: {str(e)}")

            return code, programming_language
        except openai.APIConnectionError as e:
            # Handle connection error here
            print(f"Failed to connect to OpenAI API: {e}")
        except openai.RateLimitError as e:
            # Handle rate limit error (we recommend using exponential backoff)
            print(f"OpenAI API request exceeded rate limit: {e}")
        except openai.APIError as e:
            # Handle API error here, e.g. retry or log
            print(f"OpenAI API returned an API Error: {e}")
        except Exception as e:
            print(f"An error occured in the API: {e}")
            # return None
