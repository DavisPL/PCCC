// Define a set of tuples
datatype Tuple = Tuple(int, int)

// Function to find an element in a set of tuples
method FindElementInSet(s: seq<Tuple>, target: int) returns (found: bool)
  ensures found == (exists t :: t in s && (t == target || t.1 == target))
{
  found := false;
  var t: Tuple;
  var i := 0;
  while i < |s| 
  invariant 0 <= i <= |s|
  {
    if s[i] == target || t.1 == target {
      found := true;
      break;
    }
  }
}

// Example usage
method Main() {
  var s: seq<Tuple> := [Tuple(1, 2), Tuple(3, 4), Tuple(5, 6)];
  var target := 3;
  var found := FindElementInSet(s, target);
  assert found;
}
