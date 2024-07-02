// Predicate to check if an integer is in an array
predicate InArray(arr: array<int>, x: int)
    reads arr // Specify what the predicate is allowed to read
{
    exists i :: 0 <= i < arr.Length && arr[i] == x
}

method IntersectArrays(a: array<int>, b: array<int>) returns (result: seq<int>)
    requires a != null && b != null // Ensure the arrays are not null
    ensures forall x :: x in result ==> (InArray(a, x) && InArray(b, x))  // All elements in result are in both a and b
    ensures forall x :: (InArray(a, x) && InArray(b, x)) ==> x in result  // All common elements are in result
    ensures forall i, j :: 0 <= i < j < |result| ==> result[i] != result[j]  // No duplicates in result
{
    var res: set<int> := {}; // Use a set to automatically handle duplicates
    for i := 0 to a.Length - 1
        invariant 0 <= i < a.Length
        invariant forall x :: x in res ==> (InArray(a, x) && InArray(b, x))
    {
        if InArray(b, a[i]) {
            res := res + {a[i]};
        }
    }
    result := res; // Convert set to sequence for the result
}
