method Fibonacci(n: nat) returns (res: nat)
{
    var a := 0;
    var b := 1;
    var i := 0;
    while i < n
    {
        var temp := a;
        a := b;
        b := temp + b;
        i := i + 1;
    }
    res := a;
}