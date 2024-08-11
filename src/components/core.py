"""
Core includes LLM models
Gets prompt from the user 

Returns
-------
_type_
    _description_
"""
import configparser
import json
import logging
import os
import pprint
import re

import numpy as np
import openai
import torch
from langchain.chains import LLMChain
from langchain.globals import set_verbose
from langchain.memory import ConversationBufferMemory
from langchain.prompts import PromptTemplate
from langchain.schema import SystemMessage
from langchain_community.callbacks.manager import get_openai_callback
from langchain_community.chat_message_histories import ChatMessageHistory
from langchain_core.chat_history import BaseChatMessageHistory
from langchain_core.runnables import RunnableConfig, RunnablePassthrough
from langchain_core.runnables.history import RunnableWithMessageHistory
from langchain_openai import ChatOpenAI
from lunary import LunaryCallbackHandler
from openai import OpenAI
from sentence_transformers import SentenceTransformer
from sklearn.metrics.pairwise import cosine_similarity
from transformers import AutoModel, AutoTokenizer

from components import prompt_generator
from utils import utils as utils


class Core:
    result = {
        "code": None,
        "programming_language": None,
        "safety_property": None,
        "required_files": None,
        "generate_code_file": None,
        
    }

    def __init__(self, max_history_length=1000):
        self.responses = []
        self.messages = []
        self.conversation_history = []
        self.max_history_length = max_history_length
        self.lunary_handler = LunaryCallbackHandler(app_id="1237e9ec-db53-4d82-b996-9ce81a650f08")
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
    
    def count_tokens(self, chain, query):
        with get_openai_callback() as cb:
            result = chain.run(query)
            print(f'Spent a total of {cb.total_tokens} tokens')

        return result, cb.total_tokens
    
    def initialize_llm(self, api_config):
        model = api_config['model']
        print(f"\n model: {model} \n")

    
        if model == "gpt-4":
            return ChatOpenAI(model_name="gpt-4", temperature=api_config['temp'],
                            openai_api_key=api_config['openai_api_key'], callbacks=[self.lunary_handler], verbose=False)
        if model == "gpt-3.5-turbo-0125":
            return ChatOpenAI(model_name="gpt-3.5-turbo-0125", temperature=api_config['temp'],
                            openai_api_key=api_config['openai_api_key'])
        # if model == "palm-2":
        #     return GooglePalm(model_name="models/text-bison-001", temperature=_api_config['temp'],
        #                     google_api_key=_api_config['google_api_key'],
        #                     max_output_tokens=4000)
    
    def get_session_history(self, session_id: str, store) -> BaseChatMessageHistory:
        if session_id not in store:
            store[session_id] = ChatMessageHistory()
        return store[session_id]
    
    
    def fix_code(self, api_config, code, error):
        
        code_fix_template = """
        The following Python code has an error:

        {code}

        The error message is:

        {error}

        Please provide a corrected version of the code that fixes this error. 
        Only provide the corrected code without any explanations.
        """
        llm = self.initialize_llm(api_config)
        code_fix_chain = LLMChain(
        llm=llm,
        prompt=PromptTemplate(
            input_variables=["code", "error"],
            template=code_fix_template
         )
        )
        return code_fix_chain.run(code=code, error=error)
        
    def invoke_llm(self, api_config, env_config, new_task,
              example_db_5_tasks,
            #   vc_example_selector,
            #   spec_example_selector,
              code_example_selector,
            #   vc_prompt_template,
              code_prompt_template,
              K, filesystem_api_ref):
        print("\n inside invoke_llm")
        store = {}
        llm = self.initialize_llm(api_config)
        api_key = api_config['openai_api_key']
        temperature = api_config['temp']
        # vc_shot_count = int(env_config["vc_shot_count"])
        code_shot_count = int(env_config["code_shot_count"])
     

        # Required for similarity_example_selector without lanchain
        # spec_examples_ids = []
        # for key, task_list in similar_tasks.items():
        #     print(f"Key: {key}")
        #     for task in task_list:
        #         print(f"Task ID: {task['task_id']}")
        #         print(f"Task Description: {task['task_description']}")
        #         print()  # Add a blank line for better readability
        #         spec_examples_ids.append(task['task_id'])
        # print(f"\n spec_examples_ids \n {spec_examples_ids}")
   
        # similar_tasks = spec_example_selector.select_examples(new_task)    
        # print(f"\n vc_example_selector \n {vc_example_selector}")

        spec_examples_ids = [1, 2, 3, 4, 5]
        
        prompt_gen = prompt_generator.PromptGenerator()
        # specification_prompt = prompt_gen.create_few_shot_specification_prompts(spec_examples_ids,
        #                                                                           example_db_5_tasks,
        #                                                                           vc_prompt_template)


 
        # print("\n Is specification_prompt correct ??????????????//////////////////////")
        # print(specification_prompt)
        # Memory
        # specification_memory = ConversationBufferMemory(input_key='task', memory_key='chat_history')

        
        # specification_chain = LLMChain(llm=llm, prompt=specification_prompt, verbose=False, output_key='specifications',
        #                             memory=specification_memory)
        
        

        print("\n new_task_description \n", new_task['task_description'])
        # Specification Prompt Response
        # with get_openai_callback() as cb_spec:
        #     specification_response = specification_chain.run(new_task['task_description'])
        # print(f'\n Spent a total of {cb_spec.total_tokens} tokens for verification \n')
        # print(f"\n specification_response: \n {specification_response} \n")
        # next_input_task_with_spec = utils.parse_specification_response(new_task, specification_response)
        
        # print(f"\n next_input_task_with_spec: \n {next_input_task_with_spec} \n")
        # spec_similar_code_tasks = code_example_selector.select_examples(next_input_task_with_spec)
        # print(f"\n spec_similar_code_tasks = \n {spec_similar_code_tasks} \n")
        similar_code_tasks = code_example_selector.select_examples(new_task)
        code_examples_ids = [t['task_id'] for t in similar_code_tasks]
        # print(f"\n code_examples_ids \n {code_examples_ids}")
        # print(f"\n example_db_5_tasks: \n {example_db_5_tasks}")
        api_reference_dict = json.loads(filesystem_api_ref)
        api_reference = api_reference_dict["api_reference"]
        code_prompt = prompt_gen.create_few_shot_code_prompts(code_examples_ids, example_db_5_tasks, code_prompt_template, api_reference)
    
        print(f"new task: {new_task['method_signature']}")
        generated_prompt = code_prompt.format(input=[new_task['task_description'], new_task['method_signature']])
        # print(f"\n generated_prompt: \n{generated_prompt}")
        # Convert the prompt to a string (it should already be a string, but this ensures it)
        prompt_string = str(generated_prompt)
        with open("/Users/pari/pcc-llms/output/generated_prompt.txt", "w") as file:
            file.write(prompt_string)
        # print(f"\n ================================\n code_prompt")                                                            
        # print(f"{code_prompt}")
        # print(f"\n ================================") 
        # utils.write_to_file("/Users/pari/pcc-llms/output/code_prompt.txt", code_prompt)
        
        # print(f"\n base_output_path {env_config["base_output_path"]} \n")
        # prompt_path = os.path.join(env_config["base_output_path"],
        #                         "dynamic-few-shot-prompt-" + str(K) + ".txt")
        # try:
        #     with open(prompt_path, "w", encoding='utf-8') as f:
        #             f.write(code_prompt.get_prompts())
        #             f.close()
        # except FileNotFoundError:
        #         print(f"Error: The file {prompt_path} does not exist.")
        # except IOError as e:
        #         print(f"Error reading the file {prompt_path}: {str(e)}")
        
        # config = RunnableConfig({"callbacks": [handler]})        
        # ************************** langchain deprecated **************************
        # code_memory = ConversationBufferMemory(input_key='task', memory_key='chat_history')
        # print (f"\n code_memory: {code_memory} \n")
        # code_chain = LLMChain(llm=llm, prompt=code_prompt, verbose=False, output_key='script', memory=code_memory)
        
  
        # **************************************************************************
        # Create memory
        code_memory = ConversationBufferMemory(input_key='task', memory_key='chat_history', return_messages=True)
        # code_memory = ConversationBufferMemory(input_key=['task', 'api_reference'], memory_key='chat_history', return_messages=True)
        code_chain = LLMChain(llm=llm, prompt=code_prompt, verbose=False, output_key='script', memory=code_memory)
        # # Compose the chain
        # config = RunnableConfig({"callbacks": [self.lunary_handler]})
        # code_chain = llm | code_prompt | code_memory
        # Dynamic Few-Shot Prompt Response

        # with get_openai_callback() as cb_code:
        #     set_verbose(True)
        #     handler = LunaryCallbackHandler(app_id="1237e9ec-db53-4d82-b996-9ce81a650f08")
        #     config = RunnableConfig({"callbacks": [handler]})
        #     code_response = code_chain.invoke({"task": new_task['task_description']})
        #     print(f'Spent a total of {cb_code.total_tokens} tokens for code')
        
        # Format your API reference
        # formatted_api_reference = format_api_reference(api_reference)

        # Add the API reference as a system message
        # api_ref_message = SystemMessage(content=f"API Reference:\n{formatted_api_reference}")
        # code_memory.chat_memory.add_message(api_ref_message)
        # with self.lunary_handler.trace("run_code_task") as trace:
        print(f"filesystem_api_ref: {filesystem_api_ref}")

        code_response = code_chain.run(method_signature=new_task['method_signature'], task=new_task['task_description'])
        print(f"\n code_response: {code_response} \n")
     
        code_memory.save_context({"task": new_task['task_description']}, {"output": code_response})
        memory_contents = code_memory.load_memory_variables({})
        # Set up logging
        print(f"\n memory_contents: {memory_contents} \n")
        # with get_openai_callback() as cb_code:
        #     set_verbose(True)
        #     code_response = code_chain.invoke({"task": new_task['task_description']}, config=  config)
        #     conversation_history = code_memory.load_memory_variables({})["chat_history"]
        #     code_memory.save_context({"task": new_task['task_description']}, {"output": code_response.content})
  
        saved_map = {
            "temperature": temperature,
            # "vc_example_shots": env_config["vc_shot_count"],
            "code_example_shots": env_config["code_shot_count"],
            # "spec_examples_ids": spec_examples_ids,
            # "specification_response": specification_response,
            "code_examples_ids": code_examples_ids,
            "code_response": code_response
        }
        # print(f"\n saved_map: {saved_map} \n")
        # try:
        #     with open(prompt_path, "w", encoding='utf-8') as f:
        #             f.write(code_prompt.get_prompts())
        #             f.close()
        # except FileNotFoundError:
        #         print(f"Error: The file {prompt_path} does not exist.")
        # except IOError as e:
        #         print(f"Error reading the file {prompt_path}: {str(e)}")
        # Run the specification chain and get the response
        # specification_response = self.run_specification_chain(new_task['task_description'], specification_prompt, api_key, api_config)
        # next_input_task_with_spec = utils.parse_specification_response(new_task, specification_response)
        # print(f"\n !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! \n")
        # print(f"next_input_task_with_spec: {next_input_task_with_spec}")
        # print(f"\n <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< \n")
        # print(f"spec_similar_code_tasks: {code_example_selector}")
        # if client.api_key is None:
        #     raise KeyError("API key not found!")
        # try:
        #     ai_msg = "hey"
        # #     completion = client.chat.completions.create(
        # #         model = api_config["model"],  # "gpt-4-turbo", 
        # #         #ToDo evaluate with gpt-4-turbo and gpt-4o
        # #         messages = self.messages, #A list of messages comprising the conversation so far
        # #         max_tokens = api_config['max_tokens'],  # Adjustable number of tokens to control response length
        # #         n = int(api_config['n']),  # Number of completions to generate
        # #         stop = api_config['stop'], # Stop completion tokens
        # #         temperature = float(api_config['temp']), # (0,2) default: 1
        # #         top_p = float(api_config['top_p']),  # (0,1) default: 1
        # #     )
        # #     ai_msg = completion.choices[0].message.content.strip()
        # except openai.APIConnectionError as e:
        #     # Handles connection error here
        #     print(f"Failed to connect to OpenAI API: {e}")
        # print("=========================================")
        # print(f"\n saved_map: {saved_map} \n")
        return saved_map
    
    def get_response_from_model(self, prompt, api_key, api_config):
        client = OpenAI(api_key = api_key)
        if client.api_key is None:
            raise KeyError("API key not found!")
        try:
            response = client.chat.completions.create(
                model = api_config["model"],  # "gpt-4-turbo", 
                #ToDo evaluate with gpt-4-turbo and gpt-4o
                messages = prompt, #A list of messages comprising the conversation so far
                max_tokens = api_config['max_tokens'],  # Adjustable number of tokens to control response length
                n = 2000,  # Number of completions to generate
                temperature = float(api_config['temp']), # (0,2) default: 1
            )
        except openai.APIConnectionError as e:
            # Handles connection error here
            print(f"Failed to connect to OpenAI API: {e}")
        return response.choices[0].message.content.strip()
    
    
    # Function to update conversation history
    def update_conversation_history(self, role, content):
        self.conversation_history.append({"role": role, "content": content})
        # Truncate conversation history to keep only the most recent exchanges
        if len(self.conversation_history) > self.max_history_length:
            self.conversation_history = self.conversation_history[-self.max_history_length:]

    # Function to construct the prompt with RAG
    def construct_prompt_with_rag(self, task_description, specification_prompt):
        # Combine specification_prompt with conversation history and task description
        prompt = [
            {"role": "system", "content": specification_prompt}
        ]
        prompt.extend(self.conversation_history)
        prompt.append({"role": "user", "content": task_description})
        return prompt

    # Function to run the equivalent of the specification chain
    def run_specification_chain(self, task_description, specification_prompt, api_key, api_config):
        # Get the constructed prompt with RAG
        prompt = self.construct_prompt_with_rag(task_description, specification_prompt)
        
        # Get the response from the OpenAI API
        model_response = self.get_response_from_model(prompt, api_key, api_config)
        
        # Update conversation history with the new task description and model's response
        self.update_conversation_history("user", task_description)
        self.update_conversation_history("assistant", model_response)
        
        return model_response

        
    def extract_info_from_prompt(self, prompt, pattern):
        match = re.search(pattern, prompt, re.DOTALL)
        # print(f"match: {match}")
        if match:
            # The first group (index 1) contains the captured content between the markers
            content = match.group(1).strip()  # .strip() to remove leading/trailing whitespace
            print("Found content:", content)
        else:
            print("No content found")
        return content

    def get_prompt(self, prompt_path):
        prompts = []
        prompts.append(utils.read_file(prompt_path))
        # print(f"prompts: {prompts}")
        # prompts = utils.content.split("---\n")
        # prompts = [prompt.strip() for prompt in prompts if prompt.strip()]
        return prompts

    def execute_prompt(self, api_config, env_config, prompt, output_path):
        #TODO separate the first line with role: system and the first line of prompt
        # extract specification prompt task info
        pattern = r"\[SPECIFCATION PROMPT\](.*?)\[[New Task SPEC]\]"
        specification_prompt = self.extract_info_from_prompt(prompt, pattern)
        spec_prmopt_dict = utils.parse_data_to_dict(specification_prompt)
        # extract spec task info
        pattern = r"\[SPECIFCATION PROMPT\](.*?)\[New Task\]"
        spec_new_task = self.extract_info_from_prompt(prompt, pattern)
         # extract COT prompt task info
        pattern = r"\[COT PROMPT\](.*?)\[New Task\]"
        cot_prompt = self.extract_info_from_prompt(prompt, pattern)
        # extract new task info
        pattern = r"\[New Task\](.*)"
        code_new_task = self.extract_info_from_prompt(prompt, pattern)
        specification_prompt = self.extract_info_from_prompt(prompt, pattern)
        #specifications memory
        specification_memory = ConversationBufferMemory(input_key='task', memory_key='chat_history')
        # print(f"specification_memory: {specification_memory}")
        # specification_chain = LLMChain(llm=llm, prompt=spec_prmopt_dict, verbose=False, output_key='specifications',
                                    # memory=specification_memory)
        # print(f"specification_chain: {specification_chain}")
         # Specification Prompt Response
        # specification_response = specification_chain.run(spec_new_task)
        #code prompt memory
        # code_memory = ConversationBufferMemory(input_key='task', memory_key='chat_history')
        # code_chain = LLMChain(llm=llm, prompt=cot_prompt, verbose=False, output_key='script', memory=code_memory)

        # Dynamic Few-Shot Prompt Response
        # code_response = code_chain.run(code_new_task)
        # self.prompt_ammendment("user", prompt)
        # print(f"prompt: {prompt}   ")
        completion = self.invoke_model(api_config['openai_api_key'], api_config)
       
        try:
            # TODO Add config file for the model specifications
            # TODO: Add function calling to api for a more structured json format
            response = completion.choices[0].message.content
            
            self.prompt_ammendment("user", response)
            print(f"self.responses: {self.responses}")
            self.responses.append(response)
            response_json = self.get_response_json(response)
            task_name = self.get_key_value(response_json, "task_name")
            # print(f"task_name: {task_name}")
            # discription = self.get_key_value(response_json, "discription")
            code = self.get_key_value(response_json, "code")
            safety_property = self.get_key_value(response_json, "safety_property")
            required_files = self.get_key_value(response_json, "required_files")
            programming_language = self.get_key_value(response_json, "programming_language")
            generate_code_file = self.generate_code_file(
                code, output_path, task_name)
            # generate_code_file = self.generate_code_file(
            #     code, output_path, task_name)
            self.result = {
                #  "task_name": task_name,
                #  "discription": discription,
                  "code": code,
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
            # TODO: Add a retry mechanism
            # TODO: Add a log mechanism
        return self.result

    def get_response_json(self, response):
        print(f"Are you in json format ???????? response: {response}")
        pattern = r"```dafny(.*?)```"
        response = re.search(pattern, response).group(0)
        print(f"response: {response}")
        response_json = json.loads(response)
        print(f"response_json: {response_json}")
        return response_json
    
    def get_key_value (self, response_json, key):
        # Get the value of the key in the response json object
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
        print(f"messages: {self.messages}")

    def generate_code_file(self, code, generated_code_file, task_name):
        # Generates file to save the requested code
        try:
            # utils.content = code
            filename = f"{task_name}.dfy"
            output_file_path = os.path.join(generated_code_file, filename)
            utils.write_to_file(output_file_path, code)
        except FileNotFoundError:
            print(f"Cannot find {output_file_path}")

        except IOError as e:
            print(f"Error writing into the file {output_file_path}: {str(e)}")
        except EOFError as e:
            print(f"EOFError: {str(e)}")
        return output_file_path
    