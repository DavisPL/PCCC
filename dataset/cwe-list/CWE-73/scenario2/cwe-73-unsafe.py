import os


def delete_file():
    filename = input("Enter the filename to delete: ")
    os.remove('/tmp/' + filename)

delete_file()


# User input: ../important_data.txt
# The constructed path: /tmp/../important_data.txt
# Actual file deleted: /important_data.txt
