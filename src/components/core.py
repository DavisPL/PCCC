"""
Core includes LLM models
invokes LLM models
Gets prompt from the user 

Returns
-------
_type_
    _description_
"""
import json
import logging

from langchain_core.callbacks import BaseCallbackHandler

# from langchain.errors import ChainError, LLMErrors
from langchain.globals import set_debug, set_verbose
from langchain.memory import ConversationBufferMemory
from langchain_core.prompts import PromptTemplate
from langchain_core.messages import SystemMessage
from langchain_anthropic import ChatAnthropic
from langchain_community.callbacks.manager import get_openai_callback
from langchain_community.chat_message_histories import ChatMessageHistory
from langchain_core.chat_history import BaseChatMessageHistory
from langchain_core.output_parsers import StrOutputParser
from langchain_core.runnables import (
    RunnableConfig,
    RunnablePassthrough,
    RunnableSequence,
)
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
        self.store = {}
        self.code_memory = ConversationBufferMemory(input_key='task', memory_key='chat_history', return_messages=True, verbose=True)
        self.lunary_handler = None
    def count_tokens(self, chain, query):
        with get_openai_callback() as cb:
            result = chain.run(query)
            # print(f'Spent a total of {cb.total_tokens} tokens')

        return result, cb.total_tokens

    def initialize_llm(self, model_config, api_config):
        model = model_config['model']
        if api_config["lunary_api_key"] is not None:
            self.lunary_handler = LunaryCallbackHandler(app_id=api_config["lunary_api_key"])

        if model == "gpt-4":
            return ChatOpenAI(model_name="gpt-4", temperature=model_config['temp'],
                            openai_api_key=api_config['openai_api_key'], callbacks=[self.lunary_handler], verbose=True)
        if model == "gpt-3.5-turbo-0125":
            return ChatOpenAI(model_name="gpt-3.5-turbo-0125", temperature=model_config['temp'],
                            openai_api_key=api_config['openai_api_key'], callbacks=[self.lunary_handler], verbose=True)
        if model == "claude":
            return ChatAnthropic(model="claude-3-opus-20240229", temperature=model_config['temp'],
                            api_key=api_config['claude_api_key'], callbacks=[self.lunary_handler], verbose=True)

    # def get_session_history(self, session_id: str) -> BaseChatMessageHistory:
    #     if session_id not in self.store:
    #         self.store[session_id] = ChatMessageHistory()
    #     return self.store[session_id]


    # def fix_code(self, api_config, code, error):

    #     code_fix_template = """
    #     The following Python code has an error:

    #     {code}

    #     The error message is:

    #     {error}

    #     Please provide a corrected version of the code that fixes this error. 
    #     Only provide the corrected code without any explanations.
    #     """
    #     llm = self.initialize_llm(api_config)
    #     code_fix_chain = LLMChain(
    #     llm=llm,
    #     prompt=PromptTemplate(
    #         input_variables=["code", "error"],
    #         template=code_fix_template
    #      )
    #     )
    #     return code_fix_chain.run(code=code, error=error)

    # def safe_extract_history(self, x):
    # # Safely extract chat history, returning an empty list if not found
    #     return x.get("chat_history", {}).get("chat_history", [])

    # def load_memory_debug(self, code_memory):
    #     memory_data = code_memory.load_memory_variables({})
    #     print(f"Loaded memory data: {memory_data}")  # Debug print
    #     return memory_data
    def safe_extract_history(self, x):
        chat_history = x.get("chat_history", {}).get("chat_history", [])
        # print(f"Extracted chat history: {chat_history}")  # Debug print
        return chat_history

    def add_error_to_memory(self, validation_result):
        error_feedback = f"Error occurred. Let's try again."
        self.code_memory.chat_memory.add_message(SystemMessage(content=validation_result))
        return error_feedback

    def invoke_llm(self, api_config, model_config, fewshot_config, new_task,
              example_db_5_tasks,
              code_example_selector,
              code_prompt_template,
              filesystem_api_ref, 
              validation_result = None):
        print("\n inside invoke_llm")
        store = {}
        llm = self.initialize_llm(model_config, api_config)
        temperature = model_config ['temp']
        # Configure logging
        logging.basicConfig(
            level=logging.ERROR,
            format='%(asctime)s %(levelname)s %(name)s %(message)s',
            handlers=[
                logging.FileHandler("langchain_errors.log"),
                logging.StreamHandler()
            ]
        )

        # Custom callback handler
        class ErrorLoggingCallbackHandler(BaseCallbackHandler):
            def on_chain_error(self, error: Exception, **kwargs):
                logging.error(f"Chain error: {str(error)}", exc_info=True)
            def on_tool_error(self, error: Exception, **kwargs):
                logging.error(f"Tool error: {str(error)}", exc_info=True)
            def on_llm_error(self, error: Exception, **kwargs):
                logging.error(f"LLM error: {str(error)}", exc_info=True)



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
        # Debug: Print memory contents before running the chain
        print("Memory before running the chain:")
        print(self.code_memory.load_memory_variables({}))
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
        code_example_ids = [t['task_id'] for t in similar_code_tasks]
        # print(f"\n code_example_ids \n {code_example_ids}")
        # print(f"\n example_db_5_tasks: \n {example_db_5_tasks}")
        api_reference_dict = json.loads(filesystem_api_ref)
        api_reference = api_reference_dict["api_reference"]
        # print(f"\n api_reference: \n {api_reference}")
        code_prompt = prompt_gen.create_few_shot_code_prompts(code_example_ids, example_db_5_tasks, code_prompt_template, api_reference)
        print(f"\n code_prompt: \n {code_prompt}")
        # print(f"new task: {new_task['method_signature']}")
        generated_prompt = code_prompt.format(input=[new_task['task_description'], new_task['method_signature']])
        print(f"\n generated_prompt: \n {generated_prompt}")

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
        # code_chain = LLMChain(llm=llm, prompt=code_prompt, verbose=False, output_key='script', memory=self.code_memory)


        # **************************************************************************
        # Create memory

        # code_memory = ConversationBufferMemory(input_key=['task', 'api_reference'], memory_key='chat_history', return_messages=True)
        set_debug(True)
        set_verbose(True)
        # code_chain = LLMChain(llm=llm, prompt=code_prompt, output_key='script', memory=code_memory)

        # # Compose the chain
        # config = RunnableConfig({"callbacks": [self.lunary_handler]})
        # print(f"memory_initiates: {self.code_memory.load_memory_variables({})}")
        output = StrOutputParser()


        config = RunnableConfig({"callbacks": [self.lunary_handler]})
        # print(f"config {config}")
        # code_memory.save_context({"task": new_task['task_description']}, {"output": code_response})
        # code_memory = ConversationBufferMemory(input_key='task', memory_key='chat_history', return_messages=True, verbose=True)
        # code_response = validation_result
        # print(f"\n new_task: {new_task} \n")
        # code_memory.save_context({"task": new_task["task_description"]}, {"output": new_task["output"]})
        # memory_contents = code_memory.load_memory_variables({})
        # Create the runnable sequence
        # code_runnable = RunnablePassthrough.assign(chat_history=self.code_memory.load_memory_variables)  |  {
        # "method_signature": lambda x: x["method_signature"],
        # "task": lambda x: x["task"],
        # "chat_history": self.safe_extract_history
        # } | code_prompt | llm | output
        code_runnable = code_prompt | llm | output
        # code_runnable = RunnablePassthrough.assign(chat_history=self.code_memory.load_memory_variables)  |  {
        # "method_signature": lambda x: x[method_signature]"method_signature", ""),
        # "task": lambda x: x["task"],
        # "chat_history": self.safe_extract_history
        # } | code_prompt | llm | output


        # code_response = code_chain.run(method_signature=new_task['method_signature'], task=new_task['task_description'])
        try: 
            code_response = code_runnable.invoke({"method_signature": new_task['method_signature'], "task": new_task['task_description']}, config)
        # except LangchainError as le:
        #     logging.error(f"Langchain error: {le}")       
        # except LLMErrors as lme:
        #     logging.error(f"LLM error: {lme}")
        # except ChainError as ce:
        #     logging.error(f"Chain error: {ce}")
        except Exception as e:
            logging.error(f"Error: {e}")
        # print(f"\n code_response: {code_response} \n")
        # memory_contents = self.code_memory.load_memory_variables({})
        # formatted_history = memory_contents.get('chat_history', [])
        # one line if else to return validation_result if has a value else code_response
        # print(f"\n validation_result: {validation_result} \n")
        if validation_result:
            self.add_error_to_memory(validation_result)
        else:
            self.code_memory.save_context({"task": new_task["task_description"]}, {"output": code_response})
        # result = {"task": new_task["task_description"], **memory_contents}
        # print(f"\n code_memory: {self.code_memory} \n")
        # print(f"\n memory_contents: {memory_contents} \n")
        # print("Memory after saving:")
        # print(self.code_memory.load_memory_variables({}))

        # code_memory.save_context({"task": new_task['task_description']}, {"output": code_response})
        # memory_contents = code_memory.load_memory_variables({})

        # code_with_history = RunnableWithMessageHistory(
        #     code_chain,
        #     self.get_session_history,
        #     input_messages_key="task",
        #     history_messages_key="output",
        # )
        # code_response = code_with_history.invoke({"method_signature": new_task['method_signature'], "task": new_task['task_description']})

        # Set up logging
        # print(f"\n memory_contents: {memory_contents} \n")

        # with get_openai_callback() as cb_code:
        #     set_verbose(True)
        #     code_response = code_chain.invoke({"task": new_task['task_description']}, config=  config)
        #     conversation_history = code_memory.load_memory_variables({})["chat_history"]
        #     code_memory.save_context({"task": new_task['task_description']}, {"output": code_response.content})

        saved_map = {
            "temperature": temperature,
            "code_example_shots": fewshot_config["few_shot_examples_count"],
            "code_example_ids": code_example_ids,
            "code_response": code_response
        }
        return saved_map