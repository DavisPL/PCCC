import argparse
import sys

from components import pccc


def main():
    pccc_obj = pccc.PCCC()
    pccc_obj.generate_proof_with_code()


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        prog="PCC-LLM",
        description="This program get your APi Key for the\
                                         desire large language model, get the prompt\
                                         and a path for the generated code and\
                                         generates the code with its proof",
    )
    sys.exit(main())
