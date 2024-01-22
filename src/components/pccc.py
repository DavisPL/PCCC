from components import validator, vc_generator


class PCCC:
    def __init__(self, prompt: str, generated_file_path: str, attempts: int):
        self.prompt = prompt
        self.generated_file_path = generated_file_path
        self.attempts = attempts
        print("PCCC is running!")

    def generate_proof_carrying_code(self):
        code_validator = validator.Validator()
        safety_property, code, req_files  = code_validator.request_and_validate_code(
            self.attempts, self.prompt, self.generated_file_path
        )
        try:
            assert safety_property is not None
            assert code is not None
            assert req_files is not None
            # print(f"safety_property in pccc {safety_property}")
            self.exec_vc_gen(safety_property, code, req_files)
        except Exception as e:
            print(f"PCCC cannot finish generating proof carrying code!")


    def exec_vc_gen(self, safety_property, code, req_files) -> None:
        vc_gen = vc_generator.VcGen()
        vc_gen.get_safety_property(safety_property, code, req_files)
