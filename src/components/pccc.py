import configparser
import os
import pdb
import pprint
import re
from datetime import datetime
from time import sleep
from typing import Optional, Union

from langchain.globals import set_verbose

from components import core
from components import dafny_verifier as verifier
from components import task_selector, validator, vc_generator
from utils import utils as utils


# PCCC class is the main class that runs the code validator and vc_generator
class PCCC:
    def __init__(self):
        print("PCCC is running!")
    def get_config(self):
        src_dir_path = os.path.dirname(os.getcwd())
        # ToDo: change this before pushing to the repo to get env.config from the root directory
        config_path = os.path.join(src_dir_path, 'env.config')
        if not (os.path.exists(config_path)):
            print(f"Given Config Path: {config_path}")
            print("env.config not found!!")
            return
        config = configparser.ConfigParser()
        config.read(config_path)
        api_config = dict()
        api_config["openai_api_key"] = config.get('DEFAULT', 'openai_api_key')
        api_config["google_api_key"] = config.get('DEFAULT', 'google_api_key')
        api_config["claude_api_key"] = config.get('DEFAULT', 'claude_api_key')
        api_config["lunary_api_key"] = config.get('DEFAULT', 'lunary_api_key')
        api_config["model"] = config.get('DEFAULT', 'model')
        api_config["temp"] = float(config.get('DEFAULT', 'temp'))
        api_config["max_tokens"] = int(config.get('DEFAULT', 'max_tokens'))
        api_config["n"] = int(config.get('DEFAULT', 'n'))
        api_config["top_p"] = config.get('DEFAULT', 'top_p')
        api_config["stop"] = config.get('DEFAULT', 'stop')

        env_config = dict()
        env_config["K_run"] = config.get('DEFAULT', 'K_run')
        env_config["cool_down_time"] = config.get('DEFAULT', 'cool_down_time')
        env_config["task_path"] = config.get('DEFAULT', 'task_path')
        env_config["base_output_path"] = config.get('DEFAULT', 'base_output_path')
        env_config["interface_path"] = config.get('DEFAULT', 'interface_path')
        env_config["example_db_json_path"] = config.get('FEWSHOT', 'example_db_json_path')
        env_config["api_reference_path"] = config.get('FEWSHOT', 'api_reference_path')
        env_config["code_shot_count"] = config.get('FEWSHOT', 'code_shot_count')
        return api_config, env_config
    
    def generate_output_paths(self, task,  temp, K, model, base_path):
        current_time = datetime.now().strftime("%Y-%m-%d")
        task_base_path = os.path.join(base_path, "task_id" + "_" + str(task['task_id'])+ "_" + "generated@" + current_time)
        if not os.path.exists(task_base_path):
            os.makedirs(task_base_path)
        out_paths = dict()
        common_path = "task_id" + "_" + str(task['task_id']) + "-" + model + "-" + "temp_" + str(
            temp) + "-" + "k_" + str(K)
        out_paths["saved_path"] = os.path.join(task_base_path, common_path + ".json")
        out_paths["dfy_src_path"] = os.path.join(task_base_path, common_path + ".dfy")
        out_paths["verification_path"] = os.path.join(task_base_path, common_path + "_verification_log.txt")
        return out_paths

    
    def get_spec_code_prompts(self, template_path):
        script_dir_path = os.path.dirname(os.getcwd())
        code_prompt_path = os.path.join(script_dir_path, template_path)
        code_template = utils.read_file(code_prompt_path)
        return code_template
        
    
    def prepare_model_response(self, task, temp, K, model, dafny_code, isVerified, saved_map, total_no_errors):
        return {
            "id": task['task_id'],
            "K": K,
            "temperature": temp,
            "task_id": task['task_id'],
            "task_description": task['task_description'],
            "model": model,
            "dafny_code": dafny_code,
            "isVerified": isVerified,
            "code_example_shots": saved_map["code_example_shots"],
            "code_response": saved_map["code_response"],
            "code_examples_ids": saved_map["code_examples_ids"],
            "total_no_errors": total_no_errors,
        }

    
    
    def get_filesystem_api_ref(self, env_config):
        api_ref = utils.load_json(env_config["api_reference_path"])
        formatted_ref = utils.format_api_reference(api_ref)
        return formatted_ref
        
    
    def execute_dynamic_few_shot_prompt(self, api_config, env_config):
        # load example db
        example_db_tasks = utils.load_json(env_config['example_db_json_path'])
        examples_db_for_cot_prompt = utils.get_examples_id_task_specification_pair(example_db_tasks)
        code_prompt_template = self.get_spec_code_prompts('src/prompts_template/COT_TEMPLATE.file')
        all_response = []
        tasks = utils.load_json(env_config['task_path'])
        model = api_config['model']
        code_example_selector = task_selector.get_semantic_similarity_example_selector(
        api_config['openai_api_key'], example_db_tasks = examples_db_for_cot_prompt,
        number_of_similar_tasks = int(env_config['code_shot_count']))
        filesystem_api_ref = self.get_filesystem_api_ref(env_config)
        llm_core = core.Core()
        code_validator = validator.Validator()
        for t in tasks:
            task = tasks[t]
            task_spec = {
                "task_id": task['task_id'],
                "task_description": task['task_description'],
                "method_signature": task['method_signature'],
            }
            for run_count in range(1, int(env_config["K_run"]) + 1):
                output_paths = self.generate_output_paths(task = task_spec, temp = api_config["temp"],  K = run_count,
                                             model = model,
                                             base_path = env_config["base_output_path"])
                try:
                    saved_response = llm_core.invoke_llm(api_config, env_config, new_task=task_spec,
                                                    example_db_5_tasks=example_db_tasks,    
                                                    code_example_selector=code_example_selector,
                                                    code_prompt_template=code_prompt_template,
                                                     K = run_count, filesystem_api_ref = filesystem_api_ref)
                    
                    interface_path = os.path.join(env_config["interface_path"])
                    response_with_fileio_lib = utils.prepend_include_to_code(saved_response['code_response'], interface_path)
                    saved_response['code_response'] = response_with_fileio_lib
                    isVerified, parsedCode, errors = verifier.verify_dfy_src(saved_response['code_response'],
                                                                    output_paths['dfy_src_path'],
                                                                    output_paths['verification_path'])
                    # print(f"\n errors: {errors}")
                    validation_result, total_no_errors = code_validator.validate_code(error_message = errors, parsed_code = parsedCode)
                    # print(f"\n validation_result: {validation_result}")
                    # print(f"\n parsedCode: {parsedCode}")
                    # print(f"\n errors: {errors}")
                    saved_map = self.prepare_model_response(task=task_spec, temp=api_config['temp'], K=run_count,
                                                    model=model, dafny_code=validation_result, isVerified=isVerified,
                                                   saved_map=saved_response, total_no_errors=total_no_errors)
                    if isVerified:
                        utils.save_to_json(saved_map, output_paths["saved_path"])
                        all_response.append(saved_map)
                        print("\n Task:" + task['task_id'] + " Verified @K=" + str(run_count) + ", saved, ignore next runs.")
                        break
                    if run_count == int(env_config["K_run"]):
                        all_response.append(saved_map)
                    utils.save_to_json(saved_map, output_paths["saved_path"])
                    print("\n Task:" + task['task_id'] + " Not Verified, saved, continue next runs.")
                except Exception as e:
                    print("Error while processing => " + task['task_id'] + "in temperature =>" + str(
                    api_config['temp']) + str(e))
                sleep(int(env_config['cool_down_time']))
        utils.save_to_json(all_response,
                            os.path.join(env_config["base_output_path"],
                                        "few-shot-prompt-" + model + ".json"))

    # Generate proof carrying code completions
    def generate_proof_with_code(self):
        api_config , env_config = self.get_config()
        self.execute_dynamic_few_shot_prompt(api_config, env_config)

    def exec_vc_gen(self, safety_property, code, req_files) -> None:
        vc_generator.VcGen.get_safety_property(safety_property, code, req_files)
