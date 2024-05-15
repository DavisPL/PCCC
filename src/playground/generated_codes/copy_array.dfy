method CopyArray(src: array<int>, dest: array<int>)
  requires src != null && dest != null && src.Length == dest.Length
  modifies dest
  ensures forall i :: 0 <= i < src.Length ==> dest[i] == src[i]
{
  var i := 0;
  while i < src.Length
    invariant 0 <= i <= src.Length
    invariant forall j :: 0 <= j < i ==> dest[j] == src[j]
  {
    dest[i] := src[i];
    i := i + 1;
  }
}