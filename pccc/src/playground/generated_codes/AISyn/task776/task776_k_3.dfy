// Predicate to determine if a character is a vowel
predicate IsVowel(c: char)
{
    c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u' ||
    c == 'A' || c == 'E' || c == 'I' || c == 'O' || c == 'U'
}

// Method to count characters with vowel neighbors
method CountCharsWithVowelNeighbors(s: string) returns (count: int)
    ensures count >= 0  // The count should always be non-negative
{
    count := 0;
    if |s| < 3 {
        // If the string has fewer than 3 characters, there can be no such characters with vowels as both neighbors
        return;
    }
    // Check for characters with vowel neighbors
    for i := 1 to |s| - 2
        invariant 1 <= i <= |s| - 2
        invariant count >= 0
    {
        if (IsVowel(s[i - 1]) && IsVowel(s[i + 1])) {
            count := count + 1;
        }
    }
}
