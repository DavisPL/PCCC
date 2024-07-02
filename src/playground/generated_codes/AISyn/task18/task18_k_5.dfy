method RemoveCharsFromFirstString(s1: string, s2: string) returns (result: string)
    ensures forall c :: c in result ==> !(c in s2)  // No character in result is from s2
    ensures forall c :: c in s1 && !(c in s2) ==> c in result  // All characters from s1 not in s2 are in result
    ensures |result| == count k: int | 0 <= k < |s1| && !(s1[k] in s2)  // Length of result matches the count of valid characters
{
    result := "";
    var charSet: set<char> := set i: int | 0 <= i < |s2| :: s2[i];  // Set of characters from s2

    if |s1| == 0 {
        return;  // Early exit if s1 is empty
    }

    for i := 0 to |s1| - 1
        invariant 0 <= i < |s1|
        invariant forall j :: 0 <= j <= i ==> (s1[j] in charSet ==> !(s1[j] in result))
        invariant forall j :: 0 <= j < i ==> (s1[j] !in charSet ==> s1[j] in result)
        invariant |result| == count k: int | 0 <= k <= i && !(s1[k] in charSet)
    {
        if !(s1[i] in charSet) {
            result := result + [s1[i]];  // Append char if not in charSet, wrapped in a sequence
        }
    }
}
