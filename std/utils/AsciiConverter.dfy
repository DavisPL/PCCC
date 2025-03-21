include "Utils.dfy"
module AsciiConverter {
  import Utils
  method CharToAscii(c: char) returns (asciiValue: bv8)
    requires 0 <= c as nat < 255 // Ensures 0 <= c < 255 // Ensures the input is a valid 8-bit ASCII value
    ensures 0 <= asciiValue < 255 && asciiValue == (c as nat) as bv8 // Ensures the output is a valid 8-bit ASCII value
  {
    asciiValue := (c as nat) as bv8; // Convert character to ASCII and store as bv8
  }
  method strToByte(s: string) returns (contentBytes: seq<bv8>)
  requires |s| > 0 
  requires forall i :: 0 <= i < |s| ==> 0 <= s[i] as int < 255
  ensures |contentBytes| == |s|
  ensures forall i :: 0 <= i < |contentBytes| ==> contentBytes[i] == s[i] as nat as bv8
  {
    var i := 0;
    contentBytes := [];
    
    while i < |s|
      invariant 0 <= i <= |s|
      invariant |s| >= |contentBytes|
      invariant forall j :: 0 <= j < |contentBytes| ==> contentBytes[j] == s[j] as nat as bv8
      invariant |contentBytes| == i
      decreases |s| - i
    {
        var convertedChar: bv8 := CharToAscii(s[i]);
        contentBytes := contentBytes + [convertedChar];
        i := i + 1;
    }

  }

  method ByteToString(bytes: seq<bv8>) returns (s: string)
  requires |bytes| >= 0
  ensures |s| == |bytes|
  ensures forall i :: 0 <= i < |bytes| ==> s[i] as nat == bytes[i] as nat
  {
    var i := 0;
    s := "";

    while i < |bytes|
      invariant 0 <= i <= |bytes|
      invariant |s| == i
      invariant forall j :: 0 <= j < i ==> s[j] as nat == bytes[j] as nat
      decreases |bytes| - i
    {
      var n: nat := bytes[i] as nat;
      var c: char := n as char;
      s := s + [c];
      i := i + 1;
    }
  }
}