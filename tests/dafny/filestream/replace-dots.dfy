predicate IsDotSlashBackslash(c: char)
{
c == ' ' || c == '/' || c == '.'|| c == '\\'
}

method RemoveDotSlashBackslash(s: string) returns (v: string)
  ensures |v| <= |s|
  ensures forall i :: 0 <= i < |v| ==> (!IsDotSlashBackslash(v[i]))
  ensures forall i :: 0 <= i < |s| ==> (IsDotSlashBackslash(s[i]) || (exists j :: 0 <= j < |v| && v[j] == s[i]))
{
  var s' : string := [];
  for i := 0 to |s|
    invariant 0 <= i <= |s|
    invariant |s'| <= i
    invariant forall k :: 0 <= k < |s'| ==> (!IsDotSlashBackslash(s'[k]))
    invariant 
    invariant forall k :: 0 <= k < i ==> (IsDotSlashBackslash(s[k]) || (exists j :: 0 <= j < |s'| && s'[j] == s[k]))
  {
    if IsDotSlashBackslash(s[i])
    {
      // Skip this character
      continue;
    }
    else
    {
      s' := s' + [s[i]];
    }
    assert forall k :: 0 <= k < i ==> (IsDotSlashBackslash(s[k]) || (exists j :: 0 <= j < |s'| && s'[j] == s[k]));
  }
  return s';
}



method RemoveDotSlashBackslashTest() {
  var out1 := RemoveDotSlashBackslash("Python language/ Programming\\ language.");
  expect out1 == "Python language Programming language";

  var out2 := RemoveDotSlashBackslash("a.b/c\\d e f");
  expect out2 == "abcd e f";

  var out3 := RemoveDotSlashBackslash("ram reshma/ram\\rahim.");
  expect out3 == "ram reshmaramrahim";
}

method Main() {
  RemoveDotSlashBackslashTest();
}