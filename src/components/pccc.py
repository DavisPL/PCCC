import configparser
import os
import pdb
import pprint
import re
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
        config_path = os.path.join(src_dir_path, 'dpl.config')
        if not (os.path.exists(config_path)):
            print(f"Given Config Path: {config_path}")
            print("env.config not found!!")
            return
        config = configparser.ConfigParser()
        config.read(config_path)
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
        env_config["task_path"] = config.get('DEFAULT', 'task_path')
        env_config["base_output_path"] = config.get('DEFAULT', 'base_output_path')
        env_config["interface_path"] = config.get('DEFAULT', 'interface_path')
        
        env_config["example_db_json_path"] = config.get('FEWSHOT', 'example_db_json_path')
        # env_config["vc_methods_api_path"] = config.get('FEWSHOT', 'vc_methods_api_path')
        # env_config["vc_shot_count"] = config.get('FEWSHOT', 'vc_shot_count')
        env_config["code_shot_count"] = config.get('FEWSHOT', 'code_shot_count')
        return api_config, env_config
    
    def get_output_paths(self, task,  temp, K, model, base_path):
        task_base_path = os.path.join(base_path, "task_id" + "_" + str(task['task_id']))
        if not os.path.exists(task_base_path):
            os.makedirs(task_base_path)
        out_paths = dict()
        common_path = "task_id" + "_" + str(task['task_id']) + "-" + model + "-" + "temp_" + str(
            temp) + "-" + "k_" + str(K)
        out_paths["saved_path"] = os.path.join(task_base_path, common_path + ".json")
        out_paths["dfy_src_path"] = os.path.join(task_base_path, common_path + ".dfy")
        out_paths["verification_path"] = os.path.join(task_base_path, common_path + "_verification_log.txt")
        return out_paths

    
    def get_spec_code_prompts(self):
        script_dir_path = os.path.dirname(os.getcwd())
        # print(f"script_dir_path: {script_dir_path}")
        # spec_prompt_path = os.path.join(script_dir_path, 'src/prompts_template/COT_VC_TEMPLATE.file')
        # vc_prompt_path = os.path.join(script_dir_path, 'src/prompts_template/COT_VC_TEMPLATE.file')
        code_prompt_path = os.path.join(script_dir_path, 'src/prompts_template/COT_VC_CODE_TEMPLATE.file')
        # if not (os.path.exists(vc_prompt_path) or os.path.exists(code_prompt_path)):
        #     print("src/my_prompts_template/COT_VC_TEMPLATE.file or  src/my_prompts_template/COT_CODE_TEMPLATE.file!!")
        #     return
        # vc_template = utils.read_file(vc_prompt_path)
        code_template = utils.read_file(code_prompt_path)
        # return vc_template, code_template
        return code_template
    
    def prepare_model_response(self, _task, _temp, _K, _model, _dafny_code, _isVerified, _verification_bits, _saved_map):
        print(f"\n Inside prepare_model_response \n")
        # print(f"id: { _task['task_id']}")
        return {
            "id": _task['task_id'],
            "K": _K,
            "temperature": _temp,
            "task_id": _task['task_id'],
            "task_description": _task['task_description'],
            "model": _model,
            "dafny_code": _dafny_code,
            "isVerified": _isVerified,
            "verification_bits": _verification_bits,
            # "vc_example_shots": _saved_map["vc_example_shots"],
            # "api_with_preconditions": _saved_map["api_with_preconditions"],
            # "specification_response": _saved_map["specification_response"],
            "code_example_shots": _saved_map["code_example_shots"],
            "code_response": _saved_map["code_response"],
            "code_examples_ids": _saved_map["code_examples_ids"],
         
            # "spec_examples_ids": _saved_map["spec_examples_ids"]
        }

    
    
    def execute_dynamic_few_shot_prompt(self, api_config, env_config):
        # load example db
        example_db_tasks = utils.load_json(env_config['example_db_json_path'])
        # vc_methods_api = utils.load_json(env_config['vc_methods_api_path'])
    

        # prepare all example db for embedding
        # examples_db_for_spec_prompt = utils.get_examples_db_task_id_spec_pair(example_db_tasks)
        examples_db_for_cot_prompt = utils.get_examples_id_task_specification_pair(example_db_tasks)
        # vc_example_selector = utils.get_vc_methods_sp_pair(vc_methods_api)
        # vc_prompt_template, code_prompt_template = self.get_spec_code_prompts()
        code_prompt_template = self.get_spec_code_prompts()
        # print("\n What samples are we using for the prompt? \n ")
        # pprint.pprint(examples_db_for_spec_prompt)
        # pprint.pprint(examples_db_for_spec_prompt)
        # 228 task json path
        all_response = []
        tasks = utils.load_json(env_config['task_path'])
        model = api_config['model']
        # formatted_examples_db_for_spec_prompt = utils.convert_json_for_langchain(examples_db_for_spec_prompt)
        # print(f"formatted_examples_db_for_spec_prompt: {examples_db_for_spec_prompt}")
        # spec_example_selector = task_selector.get_semantic_similarity_example_selector(
        # api_config['openai_api_key'], example_db_tasks = examples_db_for_spec_prompt,
        # number_of_similar_tasks = int(env_config['vc_shot_count']))
        # vc_example_selector = task_selector.get_semantic_similarity_example_selector(
        # api_config['openai_api_key'], example_db_tasks = example_db_for_vc_prompt,
        # number_of_similar_tasks = int(env_config['vc_shot_count']))
        
        code_example_selector = task_selector.get_semantic_similarity_example_selector(
        api_config['openai_api_key'], example_db_tasks = examples_db_for_cot_prompt,
        number_of_similar_tasks = int(env_config['code_shot_count']))
        # print(f"\n code_example_selector: \n {code_example_selector}")
        
        for t in tasks:
            task = tasks[t]
            # print(f"\n task: \n  {task}")
            task_spec = {
                "task_id": task['task_id'],
                "task_description": task['task_description'],
                "method_signature": task['method_signature'],
                "all_api_with_preconditions": task['all_api_with_preconditions'],
                # "verification_methods_signature": task['spec']['verification_methods_signature'],
                # "verification_conditions": task['spec']['verification_conditions'],
            }
            # print(f"task_spec: \n {task_spec} \n\n")
            for run_count in range(1, int(env_config["K_run"]) + 1):
                output_paths = self.get_output_paths(task = task_spec, temp = api_config["temp"],  K = run_count,
                                             model = model,
                                             base_path = env_config["base_output_path"])
                # print(f"\n output_paths: {output_paths} \n")
                try:
                    llm_core = core.Core()
                    set_verbose(True)
                    saved_response = llm_core.invoke_llm(api_config, env_config, new_task=task_spec,
                                                    example_db_5_tasks=example_db_tasks,
                                                    # vc_example_selector=vc_example_selector,
                                                    # spec_example_selector=spec_example_selector,
                                                    code_example_selector=code_example_selector,
                                                    # vc_prompt_template=vc_prompt_template,
                                                    code_prompt_template=code_prompt_template,
                                                     K = run_count)
                    
                  
                    interface_path = os.path.join(env_config["interface_path"])
                    response_with_fileio_lib = utils.prepend_include_to_code(saved_response['code_response'], interface_path)
                    saved_response['code_response'] = response_with_fileio_lib
                    isVerified, parsedCode, errors = verifier.verify_dfy_src(saved_response['code_response'],
                                                                    output_paths['dfy_src_path'],
                                                                    output_paths['verification_path'])
                    # verification_info = verifier.get_verification_info(errors)
                    # Find the line number and error message
                    print(f"\n errors: {errors}")
                    verification_bits = verifier.get_all_verification_bits_count(parsedCode)

                    saved_map = self.prepare_model_response(_task=task_spec, _temp=api_config['temp'], _K=run_count,
                                                    _model=model, _dafny_code=parsedCode, _isVerified=isVerified,
                                                    _verification_bits=verification_bits, _saved_map=saved_response)
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
                                        "dynamic-few-shot-prompting-" + model + ".json"))

        # Generate proof carrying code
    def generate_proof_with_code(self):
        api_config , env_config = self.get_config()
        # print(api_config)
        # print(env_config)
        self.execute_dynamic_few_shot_prompt(api_config, env_config)
        # self.get_output_paths()
        # The validator object is created to validate the code
        attempts = env_config["K_run"]
        task_path = env_config["task_path"]
        output_path = env_config["base_output_path"]
        # The code_validator object is used to validate the code and get the safety property, code, and required files
        # code_validator = validator.Validator()
        # safety_property, code, req_files = code_validator.validate_code(
        #     attempts, task_path, output_path, api_config, env_config
        # )
        # if safety_property is None:
        #     raise ValueError("PCCC cannot find the safety property!")
        # elif code is None:
        #     raise ValueError("PCCC cannot find the code!")
        # else:
        #     pass
            # self.exec_vc_gen(safety_property, code, req_files)

    def exec_vc_gen(self, safety_property, code, req_files) -> None:
        vc_generator.VcGen.get_safety_property(safety_property, code, req_files)
