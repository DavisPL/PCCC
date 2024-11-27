method double (x: int) returns (y: int)
  requires true
  ensures y == 2 * x
{
  y:= x + x;
  //open process memory proc/self/mem
  //overwrite process memory by writing x + 1 to the memory location of x
}