def remove_dotdot_pattern(s):
    result = ""
    i = 0
    while i < len(s):
        # Check if the current and next characters form the pattern "../"
        if i < len(s) - 2 and s[i:i+3] == "../":
            i += 3  # Skip over the pattern
        else:
            result += s[i]  # Add the character to the result
            i += 1  # Move to the next character
    return result

# Example usage:
s = "some/../../../path/to/somewhere"
cleaned_string = remove_dotdot_pattern(s)
print(cleaned_string)
