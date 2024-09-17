import configparser
import os
import pdb
import pprint
import re
from datetime import datetime
from time import sleep
from typing import Optional, Union

from langchain.globals import set_verbose

from components import dafny_verifier as verifier
from components import task_selector, validator, vc_generator
from components.core import Core
from utils import utils as utils
from utils.code_generator import CodeGenerator
from utils.config_reader import ConfigReader

# PCCC class is the main class that runs the code validator and vc_generator

class PCCC:
    def __init__(self):
        print("PCCC is running!")
        self.config_reader = ConfigReader()
        self.code_generator = CodeGenerator()
        self.llm_core = Core()
        self.api_config, self.model_config, self.env_config, self.fewshot_config = self.config_reader.read_config()
        
    
    def execute_dynamic_few_shot_prompt(self):
        # load example db
        example_db_tasks = utils.load_json(self.fewshot_config['RAG_json_path'])
        examples_db_for_cot_prompt = utils.get_examples_id_task_specification_pair(example_db_tasks)
        code_prompt_template = self.code_generator.load_code_template('src/prompts_template/COT_TEMPLATE.file')
        all_response = []
        tasks = utils.load_json(self.env_config['task_path'])
        model = self.model_config['model']
        code_example_selector = task_selector.get_semantic_similarity_example_selector(
        self.api_config['openai_api_key'], example_db_tasks = examples_db_for_cot_prompt,
        number_of_similar_tasks = int(self.fewshot_config['code_shot_count']))
        filesystem_api_ref = self.code_generator.load_api_reference(self.fewshot_config)
        code_validator = validator.Validator()
        run_time = datetime.now().strftime("%Y-%m-%d-%H-%M")
        for t in tasks:
            task = tasks[t]
            task_spec = {
                "task_id": task['task_id'],
                "task_description": task['task_description'],
                "method_signature": task['method_signature'],
            }
            for run_count in range(1, int(self.model_config["K_run"]) + 1):
                output_paths = self.code_generator.generate_task_output_paths(task = task_spec, temp = self.model_config["temp"],  k_runs = run_count,
                                             model = model,
                                             base_path = self.env_config["base_output_path"], run_time = run_time)
                try:
                    saved_response = self.llm_core.invoke_llm(self.api_config, self.model_config, self.fewshot_config, new_task=task_spec,
                                                    example_db_5_tasks=example_db_tasks,    
                                                    code_example_selector=code_example_selector,
                                                    code_prompt_template=code_prompt_template,
                                                    filesystem_api_ref = filesystem_api_ref)
                    
                    interface_path = os.path.join(self.env_config["interface_path"])
                    response_with_fileio_lib = utils.prepend_include_to_code(saved_response['code_response'], interface_path)
                    saved_response['code_response'] = response_with_fileio_lib
                    is_verified, parsedCode, errors = verifier.verify_dfy_src(saved_response['code_response'],
                                                                    output_paths['dfy_src_path'],
                                                                    output_paths['verification_path'])
                    # print(f"\n errors: {errors}")
                    validation_result, total_errors = code_validator.validate_code(error_message = errors, parsed_code = parsedCode)
                    # print(f"\n validation_result: {validation_result}")
                    # print(f"\n parsedCode: {parsedCode}")
                    # print(f"\n errors: {errors}")
                    saved_map = self.code_generator.create_model_response(task=task_spec, temp=self.model_config['temp'], k_runs=run_count,
                                                    model=model, dafny_code=validation_result, is_verified=is_verified,
                                                   saved_map=saved_response, total_errors=total_errors)
                    if is_verified:
                        utils.save_to_json(saved_map, output_paths["saved_path"])
                        all_response.append(saved_map)
                        print("\n Task:" + task['task_id'] + " Verified @K=" + str(run_count) + ", saved, ignore next runs.")
                        break
                    if run_count == int(self.model_config["K_run"]):
                        all_response.append(saved_map)
                    utils.save_to_json(saved_map, output_paths["saved_path"])
                    print("\n Task:" + task['task_id'] + " Not Verified, saved, continue next runs.")
                except Exception as e:
                    print("Error while processing => " + task['task_id'] + "in temperature =>" + str(
                    self.model_config['temp']) + str(e))
                sleep(int(self.model_config['cool_down_time']))
        utils.save_to_json(all_response,
                            os.path.join(self.env_config["base_output_path"],
                                        "few-shot-prompt-" + model + ".json"))

    # Generate proof carrying code completions
    def generate_proof_with_code(self):
        self.execute_dynamic_few_shot_prompt()

    def exec_vc_gen(self, safety_property, code, req_files) -> None:
        vc_generator.VcGen.get_safety_property(safety_property, code, req_files)
