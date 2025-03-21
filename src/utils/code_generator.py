import os
from pathlib import Path

import utils.utils as utils


class CodeGenerator:
    
    @staticmethod
    def generate_task_output_paths(task, temp, k_runs, model, base_path, run_time):
        """Generates output paths for a task based on model parameters."""
        real_base_path = os.path.realpath(Path(base_path))
        task_id = task['task_id']
        # Create the task base path
        if (os.path.isabs(real_base_path) & os.path.exists(real_base_path)):
            task_base_path = os.path.join(real_base_path, f"task_id_{task_id}_generated@{run_time}")
            os.makedirs(task_base_path, exist_ok=True)
            
            # Common base path for outputs
            common_filename = f"task_id_{task_id}-{model}-temp_{temp}-k_{k_runs}"
            
            # Create the output paths
            output_paths = {
                "saved_path": os.path.join(task_base_path, f"{common_filename}.json"),
                "dfy_src_path": os.path.join(task_base_path, f"{common_filename}.dfy"),
                "verification_path": os.path.join(task_base_path, f"{common_filename}_verification_log.txt")
            }
            
            return output_paths
        else:
            raise ValueError("Base path must be an absolute path. Please provide a valid path that exists and is not a symbolic link.")

    
    @staticmethod
    def load_code_template(template_path):
        """Loads and returns the code template from the specified template path."""
        getcwd = os.getcwd()
        parent_dir = os.path.dirname(getcwd)    
        absolute_template_path = os.path.normpath(template_path)
        print(f"absolute_template_path {absolute_template_path}")
        full_template_path = os.path.join(parent_dir, absolute_template_path)
        print(f"full_template_path {full_template_path}")
        if not os.path.exists(full_template_path):
            raise ValueError("Please provide a valid template path.")
        else:
            return utils.read_file(full_template_path)
        
    
    @staticmethod
    def create_model_response(task, temp, k_runs, model, dafny_code, is_verified, saved_map, total_errors):
        """Creates a structured model response with task and model details."""
        return {
            "id": task['task_id'],
            "k_runs": k_runs,
            "temperature": temp,
            "task_id": task['task_id'],
            "task_description": task['task_description'],
            "model": model,
            "dafny_code": dafny_code,
            "is_verified": is_verified,
            "code_example_shots": saved_map.get("code_example_shots", []),
            "code_response": saved_map.get("code_response", ""),
            "code_example_ids": saved_map.get("code_example_ids", []),
            "total_errors": total_errors,
        }

    
    @staticmethod
    def load_api_reference(env_config):
        """Loads and formats the API reference from the filesystem."""
        api_reference_path = os.path.realpath(Path(env_config["api_reference_path"]))
        print(f"api_reference_path {api_reference_path}")
        if (os.path.isabs(api_reference_path) & os.path.exists(api_reference_path)):
            api_ref_data = utils.load_json(api_reference_path)
            # Format the API reference using the utility function
            return utils.format_api_reference(api_ref_data)
        else:
            raise ValueError("Please provide a valid path that exists.")