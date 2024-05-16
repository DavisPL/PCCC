import pdb
from typing import Optional, Union

from components import validator, vc_generator


# PCCC class is the main class that runs the code validator and vc_generator
class PCCC:
    def __init__(self):
        print("PCCC is running!")
    # Generate proof carrying code
    def generate_proof_carrying_code(self, prompt: str, generated_file_path: str, attempts: int):
        # The validator object is created to validate the code
        code_validator = validator.Validator()
        # The code_validator object is used to validate the code and get the safety property, code, and required files
        safety_property, code, req_files = code_validator.validate_code(
            attempts, prompt, generated_file_path
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
