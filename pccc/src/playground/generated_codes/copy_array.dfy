method CopyArray(src: array<int>, dest: array<int>)
  requires src != null && dest != null && dest.Length >= src.Length
  modifies dest
  ensures forall i :: 0 <= i < src.Length ==> dest[i] == src[i]
{
  var n := 0;
  while n < src.Length
    invariant 0 <= n <= src.Length
    invariant forall i :: 0 <= i < n ==> dest[i] == src[i]
  {
    dest[n] := src[n];
    n := n + 1;
  }
}