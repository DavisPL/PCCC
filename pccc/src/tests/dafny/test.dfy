method Abs(x: int) returns (y: int)
  ensures 0 <= y
  ensures x < 0 ==> y == -x
  ensures x >=0 ==> y == x
{
  if x < 0 {
    return -x;
  } else {
    return x;
  }
}

method Testing()
{
  var v := Abs(-2147483648);
  assert 0 <= v;
  assert v == 2147483648;
}
