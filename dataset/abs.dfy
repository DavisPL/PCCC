method Abs(x: int) returns (y: int)
  requires true
  ensures y >= 0
  ensures y == x || y == -x
{
  if x >= 0 {
    return x;
  } else {
    return -x;
  }
}