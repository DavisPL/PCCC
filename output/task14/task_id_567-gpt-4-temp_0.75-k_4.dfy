method IsSorted(a: array<int>) returns (result: bool)
    requires a != null
    ensures result <==> forall i :: 0 <= i < a.Length - 1 ==> a[i] <= a[i+1]
{
    result := true;
    for i := 0 to a.Length - 2
        invariant 0 <= i <= a.Length - 2
        invariant result <==> forall k :: 0 <= k < i ==> a[k] <= a[k+1]
    {
        if a[i] > a[i+1]
        {
            result := false;
            break;
        }
    }
}