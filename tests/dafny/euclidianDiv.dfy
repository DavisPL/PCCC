method EuclidianDiv(a: int, b: int) returns (q: int, r: int)
  requires 0 <= a && 0 < b // just added
  decreases a // Just added
  ensures a == b * q + r
  ensures 0 <= r < b
  ensures r <= a
{

  if a < b {
    q := 0;
    r := a;
  } else {
    assert a - b < a;
    var q', r' := EuclidianDiv(a - b, b);
    q := q' + 1;
    r := r';
    assert r < b;
    assert r <= a;
  }
}
method Main() {
  var a, b := 47, 13;
  var q, r := EuclidianDiv(a, b);
  print a, " = ", q, "*", b, " + ", r;
}