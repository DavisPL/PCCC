method IntersectArrays(a: array<int>, b: array<int>) returns (result: seq<int>)
    requires a != null && b != null // Ensure the arrays are not null
    ensures forall x :: x in result ==> (InArray(a, x) && InArray(b, x))  // All elements in result are in both a and b
    ensures forall x :: (InArray(a, x) && InArray(b, x)) ==> x in result  // All common elements are in result
    ensures forall i, j :: 0 <= i < j < |result| ==> result[i] != result[j]  // No duplicates in result
{
    var res: set<int> := {}; // Use a set to automatically handle duplicates
    for i := 0 to a.Length - 1
        invariant 0 <= i <= a.Length
        invariant forall x :: x in res ==> (InArray(a, x) && InArray(b, x))
    {
        if InArray(b, a[i]) && !res.Contains(a[i]) {
            res := res + {a[i]};
        }
    }

    // Convert the set to a sequence
    result := [];  // Initialize result as an empty sequence
    var tempSeq: seq<int> := [];  // Temp sequence for converting set to seq
    for i := 0 to a.Length - 1
        invariant 0 <= i <= a.Length
        invariant forall x :: x in tempSeq ==> res.Contains(x)
        invariant forall k :: 0 <= k < |tempSeq| ==> tempSeq[k] in res
    {
        if res.Contains(a[i]) {
            tempSeq := tempSeq + [a[i]];
        }
    }
    result := tempSeq;
}
