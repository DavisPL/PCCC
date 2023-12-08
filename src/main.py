import argparse
import sys

from components import validator


def main(prompt, generated_file_path, attempts):
    print("Proof Carrying LLMs")
    code_validator = validator.Validator()
    code_validator.request_and_validate_code(
        attempts, prompt, generated_file_path
    )


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        prog="PCC-LLM",
        description="This program get your APi Key for the\
                                         desire large language model, get the prompt\
                                         and a path for the generated code and\
                                         generates the code with its proof",
    )
    parser.add_argument("prompt", help="The prompt file name and path")
    parser.add_argument(
        "generated_file_path",
        help="The file name and path to save the generated code file",
    )

    parser.add_argument(
        "attempts",
        metavar="N",
        type=int,
        help="Number of compilation attempts",
    )

    args = parser.parse_args()
    print(f"args.prompt, {args.prompt}")
    print(f"args.generated_file_path, {args.generated_file_path}")
    sys.exit(
        main(args.prompt, args.generated_file_path, args.attempts)
    )
