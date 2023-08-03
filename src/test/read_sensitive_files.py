def read_file(filename):
   try:
       with open(filename, 'r') as file:
           data = file.read()
           print(data)
   except FileNotFoundError:
       print(f'The file {filename} does not exist.')
       

def main():
    read_file('./files/my_social_security_number.txt')
    
if __name__ == "__main__":
    main()
    
    
