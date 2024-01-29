import pdb
from typing import Optional, Union

from components import validator, vc_generator


class PCCC:
    def __init__(self):
        print("PCCC is running!")
        pass

    def generate_proof_carrying_code(self, prompt: str, generated_file_path: str, attempts: int):
        code_validator = validator.Validator()
        # TO DO: Handle retun values None
   
        # #    code_validator.validate_code(
        # #         attempts, prompt, generated_file_path
        # #     )
        # safety_property, code, req_files = code_validator.validate_code(
        #     attempts, prompt, generated_file_path
        # )
        #     # print(f"safety_property in pccc {safety_property}")
        safety_property, code, req_files = code_validator.validate_code(
            attempts, prompt, generated_file_path
        )
        if safety_property is None:
            raise Exception("PCCC cannot find the safety property!")
        elif code is None:
            raise Exception("PCCC cannot find the code!") 
        else:
           self.exec_vc_gen(safety_property, code, req_files)

    def exec_vc_gen(self, safety_property, code, req_files) -> None:
        vc_gen = vc_generator.VcGen()
        vc_gen.get_safety_property(safety_property, code, req_files)
