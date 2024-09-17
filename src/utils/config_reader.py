import configparser
import logging
import os
from pathlib import Path


class ConfigReader:
    def __init__(self, config_filename='env.config'):
        self.src_dir_path = Path(os.getcwd()).parent
        self.config_path = self.src_dir_path / config_filename
        
    def read_config(self):
        # Check if the config file exists
        if not self.config_path.exists():
            logging.error(f"Config file not found at {self.config_path}")
            return None, None

        # Initialize configparser and read the file
        config = configparser.ConfigParser()
        config.read(self.config_path)

        # Function to get values from config safely
        def get_config_values(section, keys):
            data = {}
            for key in keys:
                try:
                    if key in ['temp']:  # Cast to float where necessary
                        data[key] = config.getfloat(section, key)
                    elif key in ['max_tokens', 'n', 'K_run']:  # Cast to int where necessary
                        data[key] = config.getint(section, key)
                    else:
                        data[key] = config.get(section, key)
                except (configparser.NoOptionError, configparser.NoSectionError) as e:
                    logging.warning(f"Missing key or section in config: {e}")
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
        fewshot_keys = ['RAG_json_path', 'api_reference_path', 'code_shot_count']
        fewshot_config = get_config_values('FEWSHOT', fewshot_keys)


        return api_config, model_config, env_config, fewshot_config
