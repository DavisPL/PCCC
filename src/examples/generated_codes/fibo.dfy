method Fibonacci(n: nat) returns (res: nat)
requires n >= 0
ensures res >= 0
{
var a := 0;
var b := 1;
var i := n;
while(i > 0)
invariant a >= 0 && b >= 0
{
var temp := a;
a := b;
b := temp + b;
i := i - 1;
}
res := a;
}