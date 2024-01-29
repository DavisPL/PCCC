method Fibonacci(n: nat) returns (res: nat)
{
    var a := 0;
    var b := 1;
    var i := 0;
    while(i < n)
        invariant 0 <= i <= n
        invariant a == if i == 0 then 0 else a
        decreases n - i
    {
        var temp := a + b;
        a := b;
        b := temp;
        i := i + 1;
    }
    res := a;
}

method Main()
{
    var n := 10;
    var result := Fibonacci(n);
    print result;
}