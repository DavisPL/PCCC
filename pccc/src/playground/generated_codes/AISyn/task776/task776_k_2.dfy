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
    if |s| < 2 {
        return;  // If string has less than 2 characters, no characters with two neighbors exist
    }
    // Check characters with neighbors from the second character to the second-to-last character
    for i := 1 to |s| - 2
        invariant 1 <= i < |s| - 1
        invariant count >= 0
    {
        if (IsVowel(s[i - 1]) && IsVowel(s[i + 1])) {
            count := count + 1;
        }
    }
    // Check first character, only if it has at least one neighbor
    if |s| > 1 && IsVowel(s[1]) && IsVowel(s[0]) {
        count := count + 1;
    }
    // Check last character, only if it has at least one neighbor
    if |s| > 2 && IsVowel(s[|s| - 2]) && IsVowel(s[|s| - 1]) {
        count := count + 1;
    }
}
