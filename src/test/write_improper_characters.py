    
def write_to_file(filename, content):
    try:
        with open(filename, 'w') as file:
            file.write(content)
            print("Content successfully written to the file.")
    except FileNotFoundError:
       print(f'The file {filename} does not exist.')
       
def main():
   
    content = input("Enter the content to write: ")
    write_to_file('./files/my_social_security_number.txt', content)

if __name__ == "__main__":
    main()
