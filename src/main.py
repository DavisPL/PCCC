import sys
from components import validator
def main():
    print("Proof Carrying LLMs")
    print("There is nothing here!")
    
if __name__ == '__main__':
    code_validator = validator.Validator()
    code_validator.request_and_validate_code()
    sys.exit(main())  