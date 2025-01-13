import os
import fcntl

def update_user_score(username, score):
    filepath = os.path.join('user_scores', f'{username}.txt')
    if not os.path.isfile(filepath):
        print(f"Error: User file for '{username}' does not exist.")
        return

    try:
        with open(filepath, 'r+') as f:
            fcntl.flock(f, fcntl.LOCK_EX)  # Exclusive lock
            try:
                current_score = int(f.read().strip())
                new_score = current_score + score
                f.seek(0)
                f.write(str(new_score))
                f.truncate()
                print(f"{username}'s new score is {new_score}")
            finally:
                fcntl.flock(f, fcntl.LOCK_UN)  # Release the lock
    except ValueError:
        print(f"Error: Current score for '{username}' is not a valid integer.")
    except Exception as e:
        print(f"Error updating score for '{username}': {e}")