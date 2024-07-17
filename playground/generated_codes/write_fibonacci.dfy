include "fileio.dfy"

function Fib(n: nat): nat
{
  if n == 0 then 0
  else if n == 1 then 1
  else Fib(n - 1) + Fib(n - 2)
}

method ComputeFibonacci(n: nat) returns (result: nat)
  ensures result == Fib(n)
{
  var prev := 0;
  var curr := 1;

  if n == 0 {
    result := 0;
    return;
  }

  var i := 1;

  while i < n
    invariant 1 <= i <= n
    invariant if i == 1 then prev == 0 && curr == 1 else true
    invariant if i > 1 then prev == Fib(i-1) && curr == Fib(i) else true
  {
    var next := prev + curr;
    prev := curr;
    curr := next;
    i := i + 1;
  }

  result := curr;
}

method ArrayFromSeq<A>(s: seq<A>) returns (a: array<A>)
  ensures a[..] == s
{
  a := new A[|s|] ( i requires 0 <= i < |s| => s[i] );
}

method {:main} Main(ghost env: HostEnvironment)
  requires env.ok.ok()
  modifies env.ok
{
  var fname := ArrayFromSeq("file.txt");
  var f: FileStream;
  var ok: bool;
  ok, f := FileStream.Open(fname, env);

  if !ok { print "open failed\n"; return; }

  var fibResult := ComputeFibonacci(10); // Compute Fibonacci of 10
  // var data: array<byte> := ArrayFromSeq([fibResult]);

  // ok := f.Write(0, data, 0, data.Length as int32);

  print "done!\n";
}