function contains_char(s: string, c: char): bool
  requires 'a' <= c <= 'z' || 'A' <= c <= 'Z' || '0' <= c <= '9'
{
  exists i :: 0 <= i < |s| && s[i] == c
}

lemma CharAtIndexImpliesContainsC(s: string, c: char, index: int)
  requires 'a' <= c <= 'z' || 'A' <= c <= 'Z' || '0' <= c <= '9'
  requires 0 <= index < |s|
  requires s[index] == c
  ensures contains_char(s, c)
{
  // The body can be empty; Dafny can prove this automatically
}

method ContainsCharMethod(s: string, c: char) returns (result: bool)
  requires 'a' <= c <= 'z' || 'A' <= c <= 'Z' || '0' <= c <= '9'
  ensures result == contains_char(s, c)
{
  result := false;
  var i := 0;
  while i < |s|
    invariant 0 <= i <= |s|
    invariant result == (exists k :: 0 <= k < i && s[k] == c)
  {
    if s[i] == c {
      CharAtIndexImpliesContainsC(s, c, i);
      result := true;
      return;
    }
    i := i + 1;
  }
}

method Main()
{
  var s := "Hello, World!";
  // assert s[0] == 'H';
  // CharAtIndexImpliesContainsC(s, 'H', 0);  // Use the lemma to prove ContainsC(s, 'H') is true
  var containsH := ContainsCharMethod(s, 'H');
  // assert containsH;  // This assertion now holds
  if containsH {
    assert 'H' in s;
    print "String contains 'H': ", containsH, "\n";
  }

  // We can also use the lemma for other characters
  // assert s[7] == 'W';
  CharAtIndexImpliesContainsC(s, 'W', 7);
  var containsW := ContainsCharMethod(s, 'W');
  assert containsW;  // This assertion now holds
  if containsW {
    assert 'W' in s;
    print "String contains 'W': ", containsW, "\n";
  }

  // # Precondition cannot be proven
  // CharAtIndexImpliesContainsC(s, 'I', 7);
  var containsI := ContainsCharMethod(s, 'I');
  assert !containsI;  // This assertion does not hold
  if containsI {
    assert 'I' in s;
    print "String contains 'I': ", containsI, "\n";
  } else {
    assert 'I' !in s;
    print "String does not contain 'I': ","\n";
  }
}