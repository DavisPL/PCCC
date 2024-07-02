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
        return;  // If string has less than 2 characters, no internal neighbors possible
    }
    // Check from second character to second last character
    for i := 1 to |s| - 2
        invariant 0 <= i <= |s| - 1
    {
        if (IsVowel(s[i - 1]) && IsVowel(s[i + 1])) {
            count := count + 1;
        }
    }
    // Special cases for first and last characters
    if |s| > 1 && IsVowel(s[1]) {
        count := count + (if IsVowel(s[0]) then 1 else 0);
    }
    if |s| > 2 && IsVowel(s[|s| - 2]) {
        count := count + (if IsVowel(s[|s| - 1]) then 1 else 0);
    }
}
