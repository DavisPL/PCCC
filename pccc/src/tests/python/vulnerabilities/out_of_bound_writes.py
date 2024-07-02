def create_array_and_write():
    try:
        # User input for the size of the array
        size = int(input("Enter the size of the array: "))

        # Create a new array
        my_array = [0] * size

        # User input for the index to write to and the value to be written
        index = int(input("Enter the index to write to: "))
        value = int(input("Enter the value to be written: "))

        # Perform the write operation
        my_array[index] = value

        # Print the updated array
        print("Updated Array:", my_array)
    except Exception as e:
        print(f"out of bound access! The exception is: {e}")

if __name__ == "__main__":
    create_array_and_write()