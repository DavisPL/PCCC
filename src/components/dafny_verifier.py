import os
import re
import sys
from subprocess import CalledProcessError, TimeoutExpired, check_output

from utils import utils as utils


def removed_comments(string):
    # remove all occurrences streamed comments (/*COMMENT */) from string
    code = re.sub(re.compile("/\*.*?\*/", re.DOTALL), "", string)
    # remove all occurrence single-line comments (//COMMENT\n ) from string
    code_2 = re.sub(re.compile("//.*?\n"), "", code)
    return code_2.strip()


def count_method(source):
    occurrence = re.findall("method", source)
    return len(occurrence)


def count_function(source):
    occurrence = re.findall("function", source)
    return len(occurrence)


def count_predicate(source):
    occurrence = re.findall("predicate", source)
    return len(occurrence)


def count_lemma(source):
    occurrence = re.findall("lemma", source)
    return len(occurrence)


def count_while(source):
    occurrence = re.findall("while", source)
    return len(occurrence)


def count_invariant(source):
    occurrence = re.findall("invariant", source)
    return len(occurrence)


# def count_assert(source):
#     patterns = "assert.*\n"
#     occurrence = re.findall(patterns, source)
#     return len(occurrence)


def count_ensures(source):
    patterns = "ensures.*\n"
    occurrence = re.findall(patterns, source)
    return len(occurrence)


def count_requires(source):
    patterns = "requires.*\n"
    occurrence = re.findall(patterns, source)
    return len(occurrence)

def check_filestream_usage(source):
    pattern = r'\bvar\s+([a-zA-Z_]\w*)\s*:\s*FileStream\s*;?'
    occurrence = re.findall(pattern, source)
    print("occurrence", occurrence)
    return {"No of calls to FileStream": len(occurrence), "message": "Use safe APIs from the FileStream class to read, write and manipulate files."}

def check_filestream_open(source):
    pattern = r'\b(ok)\s*,\s*([a-zA-Z_]\w*)\s*:=\s*FileStream\.Open\(\s*([a-zA-Z_]\w*)\s*\)\s*;?'
    occurence = re.search(pattern, source)
    return occurence
    


def get_all_verification_bits_count(code):
    obj = {}
    # obj['method'] = count_method(code)
    obj['ensure'] = count_ensures(code)
    obj['requires'] = count_requires(code)
    obj['filestream_usage'] = check_filestream_usage(code)
    obj['filestream_open'] = check_filestream_open(code)
    print("---------------------------------")
    print("obj", obj)
    # obj['function'] = count_function(code)
    # obj['lemma'] = count_lemma(code)
    # obj['predicate'] = count_predicate(code)
    # obj['invariant'] = count_invariant(code)
    # obj['assert_count'] = count_assert(code)
    return obj

def get_verification_info(error):
    pass

def get_verification_bits_count(path):
    code = utils.read_file(path)
    return get_all_verification_bits_count(code)


def get_verification_bits_count_rq1(save_map):
    response = save_map['response']
    code = parse_code(response)
    return get_all_verification_bits_count(code)


def get_verification_bits_count_rq3(save_map):
    code = save_map['code_response']
    return get_all_verification_bits_count(code)



def get_dafny_verification_result(dfy_file_path):
    cmd_output = ""
    try:
        cmd_output = check_output(["dafny", "verify", dfy_file_path], timeout=300, encoding='utf8')
    except TimeoutExpired as e:
        return -1, -1, cmd_output  # -1, -1 time_out errors
    except CalledProcessError as e:
        cmd_output = e.output  # get the verification errors
        # if detected any parse errors
        # print(cmd_output)
        if "parse errors detected" in cmd_output:
            return -2, -2, cmd_output  # -2,-2 parser_errors
    # print(cmd_output)
    lines = cmd_output.strip().split("\n")
    last_line = lines[len(lines) - 1]
    # Example logs:
    # 'Dafny program verifier finished with 4 verified, 4 errors'
    if "verifier finished with" in last_line:
        errors = last_line.split(",")[1].strip().split(" ")[0]
        verification = last_line.split(",")[0].strip().split(" ")[5]
        return int(verification), int(errors), cmd_output
    else:
        return -3, -3, cmd_output  # -3,-3 type resolution or other errors


def parse_code(model_response):
    pattern = r'```dafny\s*\s*(.*?)\s*```'
    match = re.search(pattern, model_response, re.DOTALL)
    if match:
        return match.group(1).strip()
    else:
        return ""


def verify_dfy_src(response, dfy_source_path, verification_path):
    # parse the response
    code = parse_code(response)
    # save the code in *.dfy file
    if not os.path.exists(dfy_source_path):
        utils.write_to_file(code, dfy_source_path)
    # call verifier:
    verification, errors, cmd_output = get_dafny_verification_result(dfy_source_path)
    utils.write_to_file(cmd_output, verification_path)
    if errors == 0:
        return True, code, cmd_output
    return False, code, cmd_output
    # return true/false

def find_match(error):
    # Pattern to find the line that error occurs and the corresponding error
    pattern = r'\(([^),]+),[^)]*\):\s*Error:(.+)'
    # Finding matches for error lines
    matches = re.findall(pattern, error)
    error_res = [(match[0], match[1].strip()) for match in matches]
    return error_res

def add_comment_to_line(line, comment, code):
    # Convert the line number string to an integer
    # Attaches any exceptions to the related line
    # Returns the modified code with the comment added
    try:
        err_line = int(line)
    except ValueError:
        print(f"Unable to convert the line number string to an integer\n, {ValueError}")


    # Split the text into lines
    lines = code.split('\n')
    # Insert the comment at the specified line number
    lines[err_line - 1] += "  # " + comment  # Adjust for 0-based index
    # Join the lines back together
    modified_text = '\n'.join(lines)
    return modified_text

def get_code_with_error(response, error_code):
    code = parse_code(response)
    return code