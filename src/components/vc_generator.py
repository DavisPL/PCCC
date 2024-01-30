
import re

from utils import utils


class VcGen:
    fileio_helper = utils.FileIO()
    def __init__(self):
        print("VC generator is activated")
    # Tokenize safety property: it should include     
    def get_safety_property(self, safety_policy, code, req_files):
        file_data = []
        if (req_files):
            for file in req_files:
                result = None
                with open(file, "r") as f:
                    result = f.read()
                    f.close()

                self.insert_formal_verifications(safety_policy=safety_policy, file=file, content=result)
        else:
            pass
        print(f"file_data {file_data}")
    def insert_formal_verifications(self, safety_policy, file, content):
        pattern = '___INSERT_PRECONDITION_CLOSE___'
        repl = safety_policy
        new_contents = re.sub(pattern ,repl , content)
        with open(file, "w") as f:
            f.write(new_contents)
            f.close()
    # def translate_sp(self, safety_policy):
    #     case(safety_policy)