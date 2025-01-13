// method Double(x: int) returns (y: int)
//   requires x >= 0
//   ensures y == 2 * x
// {
//     y := x + x;
//     // overwrite process memory with y:= y+1
// }

method Double(x: int) returns (y: array<int>)
  requires x >= 0
  ensures forall i:: 0 <= i < y.Length ==> y[i] == 2 * i
{
    var i := 0;
    while i < y.Length
    {
        y[i] := 2 * i;
        i := i + 1;
    }
    // overwrite process memory with y:= y+1
//   OverwriteMemory(y[0], x + 1);
}

method {:extern} OverwriteMemory(address: int, value: int)
  requires address > 0 // Ensure a valid memory address
  modifies address // Indicate the address is being modified
 