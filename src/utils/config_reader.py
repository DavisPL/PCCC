
import logging
import os
from pathlib import Path

import yaml


class ConfigReader:
    def __init__(self, config_filename='dpl.yaml'):
        self.src_dir_path = Path(os.getcwd()).parent
        self.config_path = self.src_dir_path / config_filename

    def read_config(self):
        # Check if the config file exists
        if not self.config_path.exists():
            logging.error(f"Config file not found at {self.config_path}")
            return None, None, None, None  # Adjusted to match the number of return variables

        # Read the YAML file
        with open(self.config_path, 'r') as file:
            try:
                config = yaml.safe_load(file)
            except yaml.YAMLError as e:
                logging.error(f"Error parsing YAML file: {e}")
                return None, None, None, None

        # Function to get values from config safely, with type casting
        def get_config_values(section, keys):
            data = {}
            section_data = config.get(section, {})
            for key in keys:
                try:
                    value = section_data[key]
                    # Cast to appropriate type where necessary
                    if key in ['temp', 'top_p']:
                        data[key] = float(value)
                    elif key in ['max_tokens', 'n', 'K_run', 'few_shot_examples_count', 'cool_down_time']:
                        data[key] = int(value)
                    else:
                        data[key] = value
                except KeyError:
                    logging.warning(f"Missing key '{key}' in section '{section}'")
                except ValueError as e:
                    logging.error(f"Invalid value for key '{key}' in section '{section}': {e}")
            return data

        # Read API Keys
        api_keys = ['openai_api_key', 'google_api_key', 'claude_api_key', 'lunary_api_key']
        api_config = get_config_values('API_KEYS', api_keys)

        # Read Model Parameters
        model_keys = ['model', 'temp', 'K_run', 'top_p', 'max_tokens', 'n', 'stop', 'cool_down_time']
        model_config = get_config_values('MODEL', model_keys)

        # Read Environment Variables
        env_keys = ['task_path', 'base_output_path', 'interface_path']
        env_config = get_config_values('ENVIRONMENT', env_keys)

        # Read Few-Shot Prompting Config
        fewshot_keys = ['RAG_json_path', 'api_reference_path', 'few_shot_examples_count']
        fewshot_config = get_config_values('FEWSHOT', fewshot_keys)

        return api_config, model_config, env_config, fewshot_config