from utils import utils


class VcGen:
    def __init__(self):
        self.fileio_helper = utils.FileIO()
        print("VC generator is activated")
    # Tokenize safety property: it should include     
    def get_safety_property(self, safety_policy, code, req_files):
        print(f"safety policy is {safety_policy}")
        print(f"Recieved code in VC_gen {code}")
        print(f"req_files {req_files}")
        file_data = []
        if (req_files):
            for file in req_files:
                self.fileio_helper.read_file(file)
                file_data.append(self.fileio_helper.content)
        else:
            pass
        print(f"file_data {file_data}")
        