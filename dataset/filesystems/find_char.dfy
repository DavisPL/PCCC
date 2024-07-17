
method ContainsC(s: string, c: char) returns (result: bool)
  requires 'a' <= c <= 'z' || 'A' <= c <= 'Z' || '0' <= c <= '9'
  ensures result <==> (exists i :: 0 <= i < |s| && (s[i] == c)) || c in s
{
  result := false;
  var i := 0;
  while i < |s|
    invariant 0 <= i <= |s|
    invariant result <==> (exists k :: 0 <= k < i && (s[k] == c))
  {
    if s[i] == c {
      assert c in s;
      result := true;
      break;
    }
    assert result <==> (exists k :: 0 <= k < i && (s[k] == c));
    i := i + 1; 

  }

}

method ContainsCTest(){
  var out1:=ContainsC("pythonz", 'z');
  // expect out1==true;
  var c := 'z';
//   assert c in "pythonz";
  assert out1;

  var out2:=ContainsC("xyz.", 'z');
//   expect out2==true;
  assert 'z' in "xyz.";
  assert out2;

  var out3:=ContainsC("  lang  .", 'z');
//   expect out3==false;
    assert 'z' !in "  lang  .";
    assert !out3;

}

method Main(){
  ContainsCTest();
}
