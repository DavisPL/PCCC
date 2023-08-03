def write_to_file(file_path, content):
    try:
        with open(file_path, 'w') as file:
            file.write(content)
        print("Content successfully written to the file.")
    except Exception as e:
        print(f"Couldn't write into the {file_path} because of {e}")


def main():
    file_path = './Files/my_social_security_number.txt'
    content = "SSN is a sensitive information!\n Take care of it!\n"

    write_to_file(file_path, content)

if __name__ == "__main__":
    main()