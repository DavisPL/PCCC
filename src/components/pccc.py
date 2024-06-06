import pdb
from typing import Optional, Union

from components import validator, vc_generator
import os
import configparser

# PCCC class is the main class that runs the code validator and vc_generator
class PCCC:
    def __init__(self):
        print("PCCC is running!")
    def get_config(self):
        src_dir_path = os.path.dirname(os.getcwd())
        print(f"src_dir_path: {src_dir_path}")
        # ToDo: change this before pushing to the repo
        config_path = os.path.join(src_dir_path, 'myenv.config')
        if not (os.path.exists(config_path)):
            print("env.config not found!!")
            return
        config = configparser.ConfigParser()
        config.read(config_path)
        print(f"config: {config.get('DEFAULT', 'openai_api_key')}")
        api_config = dict()
        api_config["openai_api_key"] = config.get('DEFAULT', 'openai_api_key')
        api_config["google_api_key"] = config.get('DEFAULT', 'google_api_key')
        api_config["model"] = config.get('DEFAULT', 'model')
        api_config["temp"] = float(config.get('DEFAULT', 'temp'))
        api_config["max_tokens"] = int(config.get('DEFAULT', 'max_tokens'))
        api_config["n"] = int(config.get('DEFAULT', 'n'))
        api_config["top_p"] = config.get('DEFAULT', 'top_p')
        api_config["stop"] = config.get('DEFAULT', 'stop')

        env_config = dict()
        env_config["K_run"] = config.get('DEFAULT', 'K_run')
        env_config["cool_down_time"] = config.get('DEFAULT', 'cool_down_time')
        env_config["prompt_path"] = config.get('DEFAULT', 'prompt_path')
        env_config["base_output_path"] = config.get('DEFAULT', 'base_output_path')
        return api_config, env_config
        # Generate proof carrying code
    def generate_proof_with_code(self):
        api_config , env_config = self.get_config()
        print(api_config)
        print(env_config)
        # The validator object is created to validate the code
        attempts = env_config["K_run"]
        prompt = env_config["prompt_path"]
        output_path = env_config["base_output_path"]
        code_validator = validator.Validator()
        # The code_validator object is used to validate the code and get the safety property, code, and required files
        safety_property, code, req_files = code_validator.validate_code(
            attempts, prompt, output_path, api_config, env_config
        )
        if safety_property is None:
            raise ValueError("PCCC cannot find the safety property!")
        elif code is None:
            raise ValueError("PCCC cannot find the code!")
        else:
            self.exec_vc_gen(safety_property, code, req_files)

    def exec_vc_gen(self, safety_property, code, req_files) -> None:
        vc_gen = vc_generator.VcGen()
        vc_gen.get_safety_property(safety_property, code, req_files)
