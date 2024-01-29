include @"../filestream/fileio.dfy"

function DigitTochar(n: nat): char
  requires 0  <= n <=  9
  ensures '0' <= DigitTochar(n) <= '9'
{
  '0' + n as char // `as` is the type-casting operator
}

function NumberToString(n: nat): string
  ensures forall i : int :: 0 <= i < |NumberToString(n)| ==> '0' <= NumberToString(n)[i] <= '9'
{
  if n < 10
  // Base case: A nat on [0, 10) is just one character long.
  then [DigitTochar(n)]
  // Inductive case: Compute all but the last character, then append the final one at the end
  else NumberToString(n/10) + [DigitTochar(n % 10)]
}


method ComputeDigitTochar(n: nat) returns (result: char)
  requires 0  <= n <=  9
  ensures '0' <= result <= '9'
  ensures result == DigitTochar(n)
{
  return '0' + n as char;
}

method ComputeNumberToString(n: nat) returns (r: string)
  ensures r == NumberToString(n)
{
  if n < 10 {
    var digitToChar := ComputeDigitTochar(n);
    r := [digitToChar];
  }

  else {
    var numToChar := ComputeNumberToString(n/10);
    var digitToChar := ComputeDigitTochar(n % 10);
    r := numToChar + [digitToChar];
  }

}

function CharToByte(c: char): byte {
  if (c as int) < 0x100 then c as int as byte else 0 as byte
}

function StringToBytesRec(s: string, i: nat) : seq<byte>  // Recursively build the sequence
  requires i <= |s|
  decreases |s| - i // Ensure the function is terminating
{
  if i == |s| then
    [] // Base case: return an empty sequence if i is the length of the string
  else
    [CharToByte(s[i])] + StringToBytesRec(s, i + 1)
}

function StringToBytes(s: string) : seq<byte>
{
  StringToBytesRec(s, 0) // Start the recursion with index 0
}

method ComputeStringToBytes(s: string) returns (bytesSeq: seq<byte>)
  requires |s| > 0  // Require non-empty strings
  requires forall i: int :: 0 <= i < |s| ==> s[i] as int < 0x100  // Each character in the string must be representable as a byte
  ensures |s| == |bytesSeq|  // Ensure the length of the generated sequence matches the input string length
  ensures forall i: int :: 0 <= i < |s| ==> bytesSeq[i] == s[i] as int as byte  // Each byte should match the character in s
{
  bytesSeq := [];
  var i := 0;
  while i < |s|
    invariant 0 <= i <= |s|
    invariant |bytesSeq| == i  // Ensure that the length of bytesSeq matches the number of iterations
    invariant forall i: int :: 0 <= i < |s| ==> s[i] as int < 0x100
    invariant forall j: int :: 0 <= j < i ==> bytesSeq[j] == s[j] as int as byte  // Each element up to i matches the string's character
  {
    assert s[i] as int < 0x100;
    bytesSeq := bytesSeq + [CharToByte(s[i])];
    print bytesSeq;
    i := i + 1;  // Increment the index to move to the next character

  }

}

method ArrayFromSeq<A>(s: seq<A>) returns (a: array<A>)
  ensures a[..] == s
{
  a := new A[|s|] ( i requires 0 <= i < |s| => s[i] );
}

function Fib(n: nat): nat
{
  if n == 0 then 0
  else if n == 1 then 1
  else Fib(n - 1) + Fib(n - 2)
}

method ComputeFibonacci(n: nat) returns (result: nat)
  ensures result == Fib(n)
  requires 0 < Fib(n)
  ensures forall j : int :: 0 <= j < n ==>  Fib(j) <= Fib(j +1)
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

method FibonacciToByteSequence(n: nat) returns (byteSeq: seq<byte>)
  ensures byteSeq == StringToBytes(NumberToString(Fib(n)))
  ensures 0 <= |byteSeq|
  requires 0 < Fib(n)
  requires 0 < |NumberToString(Fib(n))|
{
  var fibo := ComputeFibonacci(n);
  assert Fib(n) == fibo;

  var fibString := ComputeNumberToString(fibo);
  assert fibString == NumberToString(Fib(n));
  byteSeq := ComputeStringToBytes(fibString);
  print "fibonacci number: ", fibo, "\n";
  print "String generated from fibonacci number: ", fibString, "\n";

}

method IsFileInSet(filename: string, files: set<string>) returns (found: bool)  // Checks at run time but we need to verify during compile time
  // Need to add preconditions for compile time
  ensures found <==> filename in files // Ensures that found is true if filename is in set of files
{
  found := filename in files;
}


method {:main} Main(ghost env: HostEnvironment)
  requires env.ok.ok()
  modifies env.ok
{

  var n := 100;
  var arrayOfBytesFib := FibonacciToByteSequence(n);
  // var files: set<string> := {"foo.txt", "bar.txt", "baz.txt"};
  var fname := ArrayFromSeq("foo.txt");
  // var fname := ArrayFromSeq("private.txt");
  var f: FileStream;
  var ok: bool;
  // ok, f := FileStream.Open(fname, env);
  // if !ok { print "open failed\n"; return; }

  // Which parts are controlled by LLM and which parts are part of the tool
  // Add preconditions to the fileio library - it is not possible for LLm to modify it
  // var isFound := IsFileInSet("foo.txt", files);

  // assert isFound == true;
  // if !isFound {
  //   print isFound, "\n";
  // }




  // The library requires the data to be an array of bytes, but Dafny has no char->byte conversions :(
  // var data: array<byte> := ArrayFromSeq([104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 33, 10]);
  var data: array<byte> := ArrayFromSeq(arrayOfBytesFib);

  // ok := f.Write(0, data, 0, data.Length as int32);
  var i := 0;
  while i < data.Length
    invariant 0 <= i <= data.Length
    decreases data.Length - i
  {

    print data[i], "\n";
    i :=  i + 1;
  }

  print "\n done! \n";

}