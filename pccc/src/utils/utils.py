import os
import re


class FileIO:
    def __init__(self):
        self.content = None

    def read_file(self, file_path):
        try:
            with open(file_path, "r", encoding='utf-8') as f:
                self.content = f.read()
                f.close()
                if os.stat(file_path).st_size == 0:
                    raise ValueError("Prompt file is empty")
        except FileNotFoundError:
            print(f"Error: The file {file_path} does not exist.")
        except IOError as e:
            print(f"Error reading the file {file_path}: {str(e)}")
        return self.content
    
    def write_file(self, file_path, string):
        try:
            with open(file_path, "w", encoding='utf-8') as f:
                f.write(string)
                f.close()
        except FileNotFoundError:
            print(f"Error: The file {file_path} does not exist.")
        except IOError as e:
            print(f"Error reading the file {file_path}: {str(e)}")

    def append_file(self, file_path):
        with open(file_path, "a", encoding='utf-8') as f:
            f.write(f"\n---\n{self.content}")
            f.close()

    def read_lines(self, file_path):
        # Read all the lines into a list
        lines = None
        try:
            with open(file_path, 'r', encoding='utf-8') as file:
                lines = file.readlines()
        except FileNotFoundError:
            print(f"Error: The file {file_path} does not exist.")
        return lines

    def write_lines(self, file_path, lines):
        try:
            with open(file_path, 'w', encoding='utf-8') as file:
                # Write the modified lines back to the file
                file.writelines(lines)
        except FileNotFoundError:
            print(f"Error: The file {file_path} does not exist.")


class CodeInstrument:
    def __init__(self):
        pass

    def spot_error_line(self, error, line):
        pattern = r"\((.*?)\)"
        matches = re.findall(pattern, error)
        if matches:
            print(f"The following matches were found: {matches}")
        else:
            print("No matches were found.")

    def count_lines(self, file_path):
        with open(file_path, 'r', encoding='utf-8') as file:
            # Count the number of lines
            count = len(file.readlines())

        return count

    def modify_line(self, file_path, line_number, new_text):
        # Modify the specified line
        file = FileIO()
        lines = file.read_lines(file_path)
        lines[line_number - 1] = '# ' + new_text + '\n'

        file.write_lines(file_path, line_number)


class PatternMatch:
    def __init__(self) -> None:
        pass

    def match(self, pattern, string):
        match = re.search(pattern, string)
        if match:
            print(
                f"The pattern '{match.group(1)}' was found.")
            return match.group(1)
        else:
            print("No match found.")
        return None


class DictParser:
    def __init__(self):
        pass

    def parse_data_to_dict(self, data):
        # Initialize an empty dictionary to store the data
        parsed_data = {}

        # Split the data by lines to process each line separately
        lines = data.strip().split('\n')

        # Variables to keep track of the current section we are parsing
        current_section = None

        for line in lines:
            line = line.strip()
            if line.endswith(':'):
                # This is a section title
                current_section = line[:-1]  # Remove the colon and set as current section
                parsed_data[current_section] = []
            else:
                # This is content under the current section
                if current_section:
                    parsed_data[current_section].append(line)

        # Post-process to turn list into a single string if it makes sense
        for key, value in parsed_data.items():
            if len(value) == 1:
                parsed_data[key] = value[0]

        return parsed_data
