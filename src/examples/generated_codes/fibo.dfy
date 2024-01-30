method Fibonacci(n: nat) returns (res: nat)
{
    var a := 0;
    var b := 1;
    var i := 0;
    while i < n
    invariant a >= 0 && b >= 0;
    invariant i <= n;
    {
        var temp := a;
        a := b;
        b := temp + b;
        i := i + 1;
    }
    assert a >= 0;
    res := a;
}
method Main()
{
    var n := 10;
    var res := Fibonacci(n);
    print res;
}