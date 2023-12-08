method IncrementArray(a: array<int>)
  modifies a
  ensures forall i :: 0 <= i < a.Length ==> a[i] == old(a[i]) + 1
{
  var n := 0;
  while n != a.Length
    invariant 0 <= n <= a.Length
    invariant forall i :: 0 <= i < n ==> a[i] == old(a[i]) + 1
    invariant forall i :: n <= i < a.Length ==> a[i] == old(a[i])

  {
    a[n] := a[n] + 1;
    assert forall i :: 0 <= i < n ==> a[i] == old(a[i]) + 1;
    assert a[n] == old(a[n]) + 1; // error
    assert forall i :: 0 <= i < n + 1 ==> a[i] == old(a[i]) + 1;
    n := n + 1;
  }
}