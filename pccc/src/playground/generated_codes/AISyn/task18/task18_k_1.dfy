// Method to remove characters from the first string that appear in the second string
method RemoveCharsFromFirstString(s1: string, s2: string) returns (result: string)
    ensures forall c :: c in result ==> !(c in s2)
    ensures forall c :: c in s1 && !(c in s2) ==> c in result
    ensures |result| <= |s1|
{
    result := "";
    var charSet : set<char> := set i: int | 0 <= i < |s2| :: s2[i];
    for i := 0 to |s1|
        invariant 0 <= i <= |s1|
        invariant forall k :: 0 <= k < i && !(s1[k] in charSet) ==> s1[k] in result
        invariant |result| <= i
    {
        if !(s1[i] in charSet) {
            result := result + [s1[i]];
        }
    }
}
