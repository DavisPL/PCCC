include "/Users/pari/pcc-llms/src/tests/dafny/filestream/fileio.dfy"

// Useful to convert Dafny strings into arrays of characters.
method ArrayFromSeq<A>(s: seq<A>) returns (a: array<A>)
  ensures a[..] == s
  ensures a.Length == |s|

{
  var i := 0;
  a := new A[|s|] ( i requires 0 <= i < |s| => s[i] );
}

lemma AsciiToChar(a: byte)
  requires 0x00 <= a as byte <= 0x7F
{
  
}
//TODO: Need to add the lemma for the conversion of array<char> to array<byte>
// lemma ChartToAscii(c: char) returns (a: array<byte>)
//   requires forall i :: 0 <= i < s.Length ==> ((s[i] >= '!' && s[i] <= '~') || s[i] == '\n' || s[i] == ' ')
//   ensures forall i :: 0 <= i < a.Length ==> 0x00 <= a[i] as byte <= 0x7F
// {
//   var i: int := 0;
//   while i < s.Length
//     invariant 0 <= i <= s.Length
//     invariant forall j :: 0 <= j < i ==> ((s[j] >= '!' && s[j] <= '~') || s[j] == '\n' || s[j] == ' ')
//     invariant forall j :: 0 <= j < i ==> 0x00 <= a[j] <= 0x7F
//     decreases s.Length - i
//   {
//     a[i] := s[i] as byte;
//     i := i + 1;
//   }
// }

// method StrToByte(s: array<char>) returns (a: array<byte>)
//   requires forall i :: 0 <= i < s.Length ==> ((s[i] >= '!' && s[i] <= '~') || s[i] == '\n' || s[i] == ' ')
//   ensures forall i :: 0 <= i < a.Length ==> 0x00 <= a[i] as byte <= 0x7F
//   ensures a.Length == s.Length
//   ensures forall i:: 0 <= i < s.Length ==> a[i] == s[i] as byte
// {
//   var i := 0;
//   a := new byte[s.Length];
//   assert a.Length == s.Length;
//  // a := new byte[s.Length] ( i requires 0 <= i < s.Length => s[i] as byte);
//   while i < s.Length
//     invariant 0 <= i <= s.Length
//     invariant forall j :: 0 <= j < i ==> ((s[j] >= '!' && s[j] <= '~') || s[j] == '\n' || s[j] == ' ')
//     invariant forall j :: 0 <= j < i ==> 0x00 <= a[j] <= 0x7F
//     decreases s.Length - i
//   {
//     a[i] := s[i] as byte;
//     i := i + 1;
//   }
//   assert forall i :: 0 <= i < a.Length ==> 0x00 <= a[i] <= 0x7F;
//   assert a.Length == s.Length;
// }

// Task1: Write without path traversal
method WriteWithoutPathTraversal(ghost env: HostEnvironment)
  requires env.ok.ok()
  modifies env.ok
{
  var fname := ArrayFromSeq("bar.txt");
  var f: FileStream;
  var ok: bool;

  ok, f := FileStream.Open(fname, env);
  // Try commenting out the following line to see that you are forced to handle errors!
  if !ok { print "open failed\n"; return; }

  // This is "hello world!" in ascii.
  // The library requires the data to be an array of bytes, but Dafny has no char->byte conversions :(
  var data: array<byte> := ArrayFromSeq([104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 33, 10]);
  var dirName2 :=  ArrayFromSeq("/Users/pari/pcc-llms/src/playground");
  // var hasDirTraversal := f.hasPathTraversal(dirName2);
  // if hasDirTraversal { print "Path Traversal detected\n"; return; } else {
  //   print "No Path Traversal detected\n";
      ok := f.Write(dirName2, 0, data, 0, data.Length as int32);
      if !ok { print "Write failed\n"; return; }
  // }
  print "done!\n";
}