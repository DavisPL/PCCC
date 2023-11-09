include "fileio.dfy"
function DigitTochar(n: nat): char
  requires 0  <= n <=  9
  ensures '0' <= DigitTochar(n) <= '9'
{
  '0' + n as char // `as` is the type-casting operator
}

function NumberToString(n: nat): string
  ensures forall i :: 0 <= i < |NumberToString(n)| ==> '0' <= NumberToString(n)[i] <= '9'
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

function CharToByte(c: char): int {
  c as int
}

method stringToBytes(s: string) returns (bytesSeq: seq<int>)
  requires |s| > 0  // Precondition requires non-empty strings
  ensures |s| == |bytesSeq|  //  // Postcondition ensure the length of the generated sequence matches the input string length
  ensures forall i: int :: 0 <= i < |s| ==> bytesSeq[i] == s[i] as int  // Each byte should match the character in s
{
  bytesSeq := [];
  var i := 0;
  while i < |s|
    invariant 0 <= i <= |s|
    invariant |bytesSeq| == i  // Ensure that the length of bytesSeq matches the number of iterations
    invariant forall j: int :: 0 <= j < i ==> bytesSeq[j] == s[j] as int  // Each element up to i matches the string's character.
  {
    bytesSeq := bytesSeq + [CharToByte(s[i])];
    i := i + 1;  // Increment the index to move to the next character.
  }

}

method Main() {
  var r := ComputeNumberToString(01234567890);
  assert r == NumberToString(01234567890);
  var charA := 'A';
  assert 65 == CharToByte(charA);
  print "r " ,r ,"\n";
  print "Ascii of c is: ", CharToByte(charA), "\n";
  var testString := "abcA";
  print "string is ", testString, "\n";
  var bytes := stringToBytes(testString);
  print "bytes ", bytes, "\n ";
  assert bytes[0] == 'a' as int; // Test each byte individually
  assert bytes[1] == 'b' as int;
  assert bytes[2] == 'c' as int;
  assert bytes[3] == 'A' as int;
  // If the testString is longer than 3 characters, this will fail
  assert |bytes| == 4; // Assert the length is as expected
  assert bytes == [97, 98, 99, 65];

}