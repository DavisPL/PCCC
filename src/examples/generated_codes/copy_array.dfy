method CopyArray(source: array<int>, destination: array<int>)
  requires source.Length == destination.Length
  modifies destination
  ensures forall i :: 0 <= i < source.Length ==> destination[i] == source[i]
{
  var n := 0;
  while n != source.Length
    invariant 0 <= n <= source.Length
    invariant forall i :: 0 <= i < n ==> destination[i] == source[i]
  {
    destination[n] := source[n];
    n := n + 1;
  }
}