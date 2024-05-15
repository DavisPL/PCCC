method BubbleSort(a: array<int>)
  modifies a
  ensures forall i, j :: 0 <= i < j < a.Length ==> a[i] <= a[j]
  ensures multiset(a[..]) == old(multiset(a[..]))
{
  var n := a.Length;
  while n > 1
    invariant 0 <= n <= a.Length
    invariant forall i, j :: 0 <= i < j < a.Length - n + 1 ==> a[i] <= a[j]
    invariant multiset(a[..]) == old(multiset(a[..]))
  {
    var i := 0;
    while i < n - 1
      invariant 0 <= i < n
      invariant forall j :: 0 <= j < i ==> a[j] <= a[j+1]
      invariant multiset(a[..]) == old(multiset(a[..]))
    {
      if a[i] > a[i+1] {
        var temp := a[i];
        a[i] := a[i+1];
        a[i+1] := temp;
      }
      i := i + 1;
    }
    n := n - 1;
  }
}