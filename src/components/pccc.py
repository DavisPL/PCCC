
import logging
import os
import time
from datetime import datetime
from pathlib import Path
from typing import Any, Dict, List, Tuple

from components import dafny_verifier as verifier
from components import task_selector, vc_generator
from components.core import Core
from components.validator import Validator
from utils import utils as utils
from utils.code_generator import CodeGenerator
from utils.config_reader import ConfigReader

# PCCC class is the main class that runs the code validator and vc_generator

class PCCC:
    def __init__(self):
        print("PCCC is running!")
        self.config_reader = ConfigReader()
        self.code_generator = CodeGenerator()
        self.validator = Validator()
        self.llm_core = Core()
        self.api_config, self.model_config, self.env_config, self.fewshot_config = self.config_reader.read_config()

    def process_tasks_with_llm(self) -> None:
            """Executes dynamic few-shot prompts for tasks using LLM and validates the responses."""
            # Load initial data
            if (os.path.exists(Path(self.fewshot_config['RAG_json_path'])) & self.fewshot_config['RAG_json_path'].endswith('.json')) is False:
                logging.error(
                    f"Output path {self.fewshot_config['RAG_json_path']} does not exist. Exiting."
                )
                return None
            else:
                example_db_tasks = utils.load_json(self.fewshot_config['RAG_json_path'])
                examples_db_for_cot_prompt = utils.extract_task_specifications(example_db_tasks)
                code_prompt_template = self.code_generator.load_code_template(
                    'src/prompts_template/COT_TEMPLATE.file'
                )
                tasks = utils.load_json(self.env_config['task_path'])
                model = self.model_config['model']
                few_shot_examples_count = int(self.fewshot_config['few_shot_examples_count'])
                k_run = int(self.model_config["K_run"])
                cool_down_time = int(self.model_config['cool_down_time'])
                temperature = self.model_config['temp']
                base_output_path = self.env_config["base_output_path"]
                interface_path = os.path.join(self.env_config["interface_path"])
                code_example_selector = task_selector.get_semantic_similarity_example_selector(
                    self.api_config['openai_api_key'],
                    example_db_tasks=examples_db_for_cot_prompt,
                    number_of_similar_tasks=few_shot_examples_count
                )
                filesystem_api_ref = self.code_generator.load_api_reference(self.fewshot_config)
                run_time = datetime.now().strftime("%Y-%m-%d-%H-%M")
                all_responses = []
                for task_id, task in tasks.items():
                    task_spec = {
                        "task_id": task['task_id'],
                        "task_description": task['task_description'],
                        "method_signature": task['method_signature'],
                    }
                    for run_count in range(1, k_run + 1):
                        output_paths = self.code_generator.generate_task_output_paths(
                            task=task_spec,
                            temp=temperature,
                            k_runs=run_count,
                            model=model,
                            base_path=base_output_path,
                            run_time=run_time
                        )
                        try:
                            saved_map, is_verified = self.process_task_run(
                                task_spec=task_spec,
                                run_count=run_count,
                                output_paths=output_paths,
                                example_db_tasks=example_db_tasks,
                                code_example_selector=code_example_selector,
                                code_prompt_template=code_prompt_template,
                                filesystem_api_ref=filesystem_api_ref,
                                interface_path=interface_path,
                                temperature=temperature,
                                model=model
                            )
                            utils.save_to_json(saved_map, output_paths["saved_path"])
                            if is_verified:
                                all_responses.append(saved_map)
                                logging.info(
                                    f"Task {task['task_id']} verified at run {run_count}, saved, ignoring next runs."
                                )
                                break
                            elif run_count == k_run:
                                all_responses.append(saved_map)
                                logging.info(
                                    f"Task {task['task_id']} not verified after {k_run} runs, saved."
                                )
                            else:
                                logging.info(
                                    f"Task {task['task_id']} not verified, saved, continuing to next run."
                                )
                        except Exception as e:
                            logging.error(
                                f"Error while processing task {task['task_id']} at temperature {temperature}",
                                exc_info=True
                            )
                        time.sleep(cool_down_time)
                output_file_path = os.path.join(
                    base_output_path, f"few-shot-prompt-{model}.json"
                )
                utils.save_to_json(all_responses, output_file_path)

    def process_task_run(
        self,
        task_spec: Dict[str, Any],
        run_count: int,
        output_paths: Dict[str, str],
        example_db_tasks: List[Dict[str, Any]],
        code_example_selector: Any,
        code_prompt_template: str,
        filesystem_api_ref: Any,
        interface_path: str,
        temperature: float,
        model: str
    ) -> Tuple[Dict[str, Any], bool]:
        """Processes a single run for a task and returns the saved map and verification status."""
        saved_response = self.llm_core.invoke_llm(
            self.api_config,
            self.model_config,
            self.fewshot_config,
            new_task=task_spec,
            example_db_5_tasks=example_db_tasks,
            code_example_selector=code_example_selector,
            code_prompt_template=code_prompt_template,
            filesystem_api_ref=filesystem_api_ref
        )
        response_with_fileio_lib = utils.prepend_include_to_code(
            saved_response['code_response'],
            interface_path
        )
        saved_response['code_response'] = response_with_fileio_lib

        is_verified, parsed_code, errors = verifier.verify_dfy_src(
            saved_response['code_response'],
            output_paths['dfy_src_path'],
            output_paths['verification_path']
        )
        validation_result, total_errors = self.validator.validate_code(
            error_message=errors,
            parsed_code=output_paths['dfy_src_path'],
            
        )
        saved_map = self.code_generator.create_model_response(
            task=task_spec,
            temp=temperature,
            k_runs=run_count,
            model=model,
            dafny_code=validation_result,
            is_verified=is_verified,
            saved_map=saved_response,
            total_errors=total_errors
        )
        return saved_map, is_verified

    # Generate proof carrying code completions
    def generate_proof_with_code(self):
        self.process_tasks_with_llm()

    def exec_vc_gen(self, safety_property, code, req_files) -> None:
        vc_generator.VcGen.get_safety_property(safety_property, code, req_files)
