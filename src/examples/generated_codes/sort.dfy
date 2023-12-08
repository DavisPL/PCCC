method SelectionSort(a: array<int>)
  modifies a
  ensures forall i, j :: 0 <= i < j < a.Length ==> a[i] <= a[j]
  ensures multiset(a[..]) == old(multiset(a[..]))
{
  var n := a.Length;
  for i := 0 to n-1
    invariant 0 <= i <= n
    invariant forall k, j :: 0 <= k < j < i ==> a[k] <= a[j]
    invariant multiset(a[..]) == old(multiset(a[..]))
  {
    var minIndex := i;
    for j := i+1 to n
    {
      if a[j] < a[minIndex] then
      {
        minIndex := j;
      }
    }
    var temp := a[i];
    a[i] := a[minIndex];
    a[minIndex] := temp;
  }
}