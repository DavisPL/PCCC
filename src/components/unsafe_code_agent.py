import os

from langchain.chains import LLMChain
from langchain_community.llms import Anthropic, OpenAI
from langchain_core.prompts import PromptTemplate

from utils import utils


class UnsafeCodeAgent:

    def __init__(self):
        print("UnsafeCodeAgent is running!")
        utils
        self.config_reader = utils.ConfigReader()
        self.api_config, self.model_config, self.env_config, self.fewshot_config = self.config_reader.read_config()

    def initialize_llm(self, model_config, api_config):
        model = model_config['model']
        # if api_config["lunary_api_key"] is not None:
        #     self.lunary_handler = LunaryCallbackHandler(app_id=api_config["lunary_api_key"])
        if model == "gpt-4":
            return OpenAI(model_name="gpt-4", temperature=model_config['temp'],
                            openai_api_key=api_config['openai_api_key'], verbose=True)
        if model == "gpt-3.5-turbo-0125":
            return OpenAI(model_name="gpt-3.5-turbo-0125", temperature=model_config['temp'],
                            openai_api_key=api_config['openai_api_key'], verbose=True)
        if model == "claude":
            return Anthropic(model="claude-3-opus-20240229", temperature=model_config['temp'],
                            api_key=api_config['claude_api_key'], verbose=True)


    def generate_unsafe_code(self, task_description):
        
        llm = self.initialize_llm(self.model_config, self.api_config)
        # Define a prompt template for the task
        template = """
        You are an expert Python developer.

        Your task is to write a Python script that accomplishes the following:

        {task_description}

        Provide only the code without any additional explanations or text.
        """

        prompt = PromptTemplate.from_template(
            input_variables=["task_description"],
            template=template,
        )
        # Create an LLMChain with the prompt and language model
        chain = prompt | llm

        # Run the chain to generate code
        code = chain.invoke(
            {
                "task_description": task_description,
            }
        )

        return code.strip()
