
import re

from utils import utils as utils


class VcGen:

    def __init__(self):
        print("VC generator is activated")
    # Tokenize safety property: it should include

    def get_safety_property(self, safety_policy, code, req_files):
        if (req_files):
            for file in req_files:
                result = None
                with open(file, "r") as f:
                    result = f.read()
                    f.close()
                # TODO: translate safety_policy to formal verification preconditions
                # vc = self.generate_vc(safety_policy)
                # self.insert_formal_verifications(
                #     verification_condition=vc, file=file, content=result)
                # self.insert_formal_verifications(
                #     verification_condition=safety_policy, file=file, content=result)
        else:
            pass

    def insert_formal_verifications(self, verification_condition, file, content):
        pattern = '___INSERT_PRECONDITION_CLOSE___'
        repl = verification_condition
        new_contents = re.sub(pattern, repl, content)
        with open(file, "w") as f:
            f.write(new_contents)
            f.close()

    def generate_vc(self, safety_policy):
        generated_vc = None
        pattern_match = utils.PatternMatch()
        sp_pattern = r"([A-Za-z]+)(?=\()"
        access_pattern = r"l\:(.*?)\,access"
        sp_class = pattern_match.match(sp_pattern, safety_policy)
        # print(f"safety_policy {safety_policy}")
        # print(f"sp_class {sp_class}")
        # print(f"access_pattern {access_pattern}")
        access_type = pattern_match.match(access_pattern, safety_policy)
        # import pdb; pdb.set_trace()
        # print(f"access_type {access_type}")
        # match sp_class:
        #     case 
        # match sp_class:
        #     case CannotAccessSensitiveFiles:
        #         generated_vc.append("require")
                
            
        return generated_vc
