def find_pattern(text, pattern):
    """
    Find all occurrences of a pattern in a given text.
    
    :param text: The text to search in
    :param pattern: The pattern to search for
    :return: A list of starting indices where the pattern is found
    """
    if not pattern:
        return []  # Return an empty list if the pattern is empty
    
    occurrences = []
    text_length = len(text)
    pattern_length = len(pattern)
    
    for i in range(text_length - pattern_length + 1):
        if text[i:i+pattern_length] == pattern:
            occurrences.append(i)
    
    return occurrences

# Test the function
text = "ABABDABACDABABCABAB"
pattern = "ABABC"
result = find_pattern(text, pattern)
print(f"Pattern '{pattern}' found at indices: {result}")

# Test with a pattern that appears multiple times
pattern2 = "ABA"
result2 = find_pattern(text, pattern2)
print(f"Pattern '{pattern2}' found at indices: {result2}")