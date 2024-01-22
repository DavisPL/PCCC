class VcGen:
    def __init__(self):

        print("VC generator is activated")
    # Tokenize safety property: it should include     
    def get_safety_property(self, safety_policy, code, req_files):
        print(f"safety policy is {safety_policy}")
        print(f"Recieved code in VC_gen {code}")
        print(f"req_files {req_files}")
        