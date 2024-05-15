import os
import threading

def append_to_file(filename, content):
    try:
        with open(filename, 'a') as file:
            file.write(content)
            print(f"Content appended to {filename}")
    except FileNotFoundError:
        print(f'The file {filename} does not exist.')

def main():
    filename = "src/files/data.txt"
    content = "This content must be written without race condition and correctly!\n"

    # Create multiple threads to append to the same file concurrently
    num_threads = 5
    threads = []
    for _ in range(num_threads):
        thread = threading.Thread(target=append_to_file, args=(filename, content))
        thread.start()
        threads.append(thread)

    # Wait for all threads to finish
    for thread in threads:
        thread.join()

if __name__ == "__main__":
    main()
