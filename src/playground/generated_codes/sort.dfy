method BubbleSort(a: array<int>)
  modifies a
  ensures forall i, j :: 0 <= i < j < a.Length ==> a[i] <= a[j]
  ensures multiset(a[..]) == old(multiset(a[..]))
{
  var n := a.Length;
  for var i := 0 to n - 1
    invariant forall k, l :: 0 <= k < l < i ==> a[k] <= a[l]
    invariant multiset(a[..]) == old(multiset(a[..]))
  {
    for var j := 0 to n - i - 2
      invariant forall k, l :: 0 <= k < l <= j ==> a[k] <= a[l]
      invariant multiset(a[..]) == old(multiset(a[..]))
    {
      if a[j] > a[j + 1] {
        var temp := a[j];
        a[j] := a[j + 1];
        a[j + 1] := temp;
      }
    }
  }
}