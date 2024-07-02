// Method to remove characters from the first string that appear in the second string
method RemoveCharsFromFirstString(s1: string, s2: string) returns (result: string)
    ensures forall c :: c in result ==> !(c in s2)  // No character in result is in s2
    ensures forall c :: c in s1 && !(c in s2) ==> c in result  // All characters in s1 not in s2 are in result
    ensures |result| <= |s1|  // Length of result is less than or equal to s1
{
    result := "";
    var charSet : set<char> := set i: int | 0 <= i < |s2| :: s2[i];  // Creating a set of characters from s2
    for i := 0 to |s1| - 1
        invariant 0 <= i < |s1|
        invariant forall k :: 0 <= k <= i && !(s1[k] in charSet) ==> s1[k] in result
        invariant forall k :: 0 <= k <= i && (s1[k] in charSet) ==> !(s1[k] in result)
        invariant |result| <= i + 1
    {
        if !(s1[i] in charSet) {
            result := result + s1[i];  // Append character if not in charSet
        }
    }
}
