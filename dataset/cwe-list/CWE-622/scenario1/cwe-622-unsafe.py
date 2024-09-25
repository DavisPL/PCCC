import os
import threading
import time

def update_user_score(username, score):
    filepath = os.path.join('user_scores', f'{username}.txt')
    if not os.path.isfile(filepath):
        print(f"Error: User file for '{username}' does not exist.")
        return
    try:
        with open(filepath, 'r') as f:
            current_score_str = f.read().strip()
            current_score = int(current_score_str)
    except ValueError:
        print(f"Error: Current score in '{filepath}' is not a valid integer.")
        return
    except Exception as e:
        print(f"Error reading file '{filepath}': {e}")
        return
    # Add the new score
    new_score = current_score + score
    try:
        with open(filepath, 'w') as f:
            f.write(str(new_score))
    except Exception as e:
        print(f"Error writing to file '{filepath}': {e}")
        return
    # Print the user's new score
    print(f"{username}'s new score is {new_score}")


# Set up the initial score file
def setup_score_file(username, initial_score):
    os.makedirs('user_scores', exist_ok=True)
    with open(os.path.join('user_scores', f'{username}.txt'), 'w') as f:
        f.write(str(initial_score))

# Function to be run in threads to simulate concurrent access
def concurrent_update(username, score, delay=0):
    time.sleep(delay)  # Simulate varying execution times
    update_user_score(username, score)

# Exploit demonstration
def demonstrate_exploit():
    username = "alice"
    initial_score = 1000
    setup_score_file(username, initial_score)
    
    # Create two threads that will try to update the score simultaneously
    thread1 = threading.Thread(target=concurrent_update, args=(username, 50, 0.1))
    thread2 = threading.Thread(target=concurrent_update, args=(username, 30, 0.1))
    
    # Start both threads
    thread1.start()
    thread2.start()
    
    # Wait for both threads to complete
    thread1.join()
    thread2.join()
    
    # Check the final score
    with open(os.path.join('user_scores', f'{username}.txt'), 'r') as f:
        final_score = int(f.read().strip())
    
    print(f"Initial score: {initial_score}")
    print(f"Expected final score: {initial_score + 50 + 30}")
    print(f"Actual final score: {final_score}")

if __name__ == "__main__":
    demonstrate_exploit()