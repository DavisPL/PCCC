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
from openai import OpenAI

from utils import utils


class LLMCore:
    load_dotenv()
    client = OpenAI(api_key = os.environ.get("OPENAI_API_KEY"))
    result = {
        "code": None,
        "programming_language": None,
        "safety_property": None,
        "required_files": None,
        "generate_code_file": None,
        
    }
    if client.api_key is None:
            raise KeyError("API key not found!")
    fileio_helper = utils.FileIO()
    def __init__(self):
        self.responses = []
        self.messages = []
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

    def get_prompt(self, prompt_path):
        prompts = []
        self.fileio_helper.read_file(prompt_path)
        
        prompts = self.fileio_helper.content.split("---\n")
        prompts = [prompt.strip() for prompt in prompts if prompt.strip()]
        return prompts

    def request_code(self, prompt, generated_code_file):
        # TODO Get model specifications from config in the function args
        #TODO separate the first line with role: system and the first line of prompt

        self.prompt_ammendment("user", prompt)
        completion = self.client.chat.completions.create(
            model = "gpt-4-turbo", 
            #ToDo evaluate with gpt-4-turbo and gpt-4o
            # returns response in JSON format 
            # model = "gpt-4-turbo-preview",
            # response_format={ "type": "json_object" },
            messages = self.messages, #A list of messages comprising the conversation so far
            max_tokens = 4096,  # Adjustable number of tokens to control response length
            n = 1,  # Number of completions to generate
            stop = None, # Stop completion tokens
            temperature = 0.1, # (0,2) default: 1
            top_p = 0.9,  # (0,1) default: 1
            # functions=[self.function],
            # function_call={"name": "json_format_composer"}
        )
        try:
            # TODO Add config file for the model specifications
            # TODO: Add function calling to api for a more structured json format
            response = completion.choices[0].message.content
            self.prompt_ammendment("assistant", response) 
            self.responses.append(response)
            response_json = self.get_response_json(response)
            code = self.get_key_value(response_json, "code")
            safety_property = self.get_key_value(response_json, "safety_property")
            print(f"Get SP ???? {safety_property}")
            required_files = self.get_key_value(response_json, "required_files")
            programming_language = self.get_key_value(response_json, "programming_language")
            print(f"Get PL ???? {programming_language}")
            generate_code_file = self.generate_code_file(
                code, generated_code_file)
            self.result = {"code": code,
                  "programming_language": programming_language,
                  "safety_property": safety_property,
                  "required_files": required_files,
                  "generate_code_file": generate_code_file, }
        except openai.APIConnectionError as e:
            # Handles connection error here
            print(f"Failed to connect to OpenAI API: {e}")
        except openai.RateLimitError as e:
            # Handles rate limit error (we recommend using exponential backoff)
            print(f"OpenAI API request exceeded rate limit: {e}")
        except openai.APIError as e:
            # Handles API error here, e.g. retry or log
            print(f"OpenAI API returned an API Error: {e}")
        except Exception as e:
            print(f"An error occured in the API: {e}")
            #TODO: Add a retry mechanism
            #TODO: Add a log mechanism
        return self.result

    def get_response_json(self, response):
        response_json = json.loads(response)
        print(f"response_json {response_json}")
        return response_json
    def get_key_value (self, response_json, key):
        try:
            value = response_json.get(key)
        except KeyError:
            print(f"KeyError: The '{key}' doesn't exist in model's resonse json object!")
        except ValueError:
            print(f"ValueError: The '{key}' key doesn't have any value!")
        return value

    def get_req_files(self, response_json):
        # Get requeired files in the prompt
        try:
            req_files = response_json.get("req_files")
        except KeyError:
             print("KeyError: The 'req_files' doesn't exist in model's resonse json object!")
        except ValueError:
            print("ValueError: The 'req_files' key doesn't have any value!")
        return req_files

    def prompt_ammendment(self, role, response):
         # Modifoes prompt to add role and messages
        self.messages.append({"role": role, "content": response})

    def generate_code_file(self, code, generated_code_file):
        # Generates file to save the requested code
        try:
            self.fileio_helper.content = code
            self.fileio_helper.write_file(generated_code_file, code)
        except FileNotFoundError:
            print(f"Cannot find {generated_code_file}")

        except IOError as e:
            print(
                f"Error writing into the file {generated_code_file}: {str(e)}")
        except EOFError as e:
            print(e)
        return generated_code_file
    # def modify_prompt(self, prompt_path):
    #     self.fileio_helper.write_file(prompt_path, )
    