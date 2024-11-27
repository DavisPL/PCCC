
method find_char (s: seq<char>, c: char) returns (index: int)
requires |s| > 0
ensures index == -1 ==> forall j :: 0 <= j < |s| ==> s[j] != c
ensures index != -1 ==> 0 <= index < |s| && s[index] == c
{
    index := -1;
    var i := 0;
    assert index != i;
    while i < |s|
        invariant 0 <= i <= |s|
        invariant index == -1 ==> forall j :: 0 <= j < i ==> s[j] != c
        invariant index != -1 ==> 0 <= index < i && s[index] == c
    {
        if s[i] == c {
            index := i;
            assert index == i;
            stringSliceLemma(s, i);
            assert s[i] == c;
            assert s[..i] + s[i..] == s;
            assert forall j :: 0 <= j < i ==> s[j] != c;
            return;
        }
        assert s[i] != c;
        i := i + 1;
    }
    assert forall j :: 0 <= j < |s| ==> s[j] != c;
    index := -1;
}

lemma stringSliceLemma (s: seq<char>, i: int)
requires 0 <= i < |s|
ensures s[..i] + s[i..] == s
{
    assert s[..i] + s[i..] == s;
}

method no_dot(s: seq<char>) returns (result: bool)
ensures result ==> forall j :: 0 <= j < |s| ==> s[j] != '.'
{
   var found_dot := false;
   var i := 0;
   while i < |s|
        invariant 0 <= i <= |s|
        invariant found_dot ==> forall j :: 0 <= j < i ==> s[j] != '.'
    {
        if s[i] != '.' {
            found_dot := false;
        }
        i := i + 1;
    }
    result := found_dot;
}


method no_dot_recursive(s: seq<char>) returns (result: bool)
ensures result ==> forall j :: 0 <= j < |s| ==> s[j] != '.'
{
    if |s| == 0 {
        result := false;
    } else {
        if s[0] == '.' {
            result := false;
        } else {
            result := no_dot_recursive(s[1..]);
        }
    }
}

method ContainsDot(s: string) returns (result: bool)
ensures !result ==> forall j :: 0 <= j < |s| ==> s[j] != '.'
ensures result ==> exists k :: 0 <= k < |s| && s[k] == '.'
{
  result := false;

  // Iterate through the string to check for '.'
  var i := 0;
  while i < |s|
    invariant 0 <= i <= |s|
    invariant !result ==> forall j :: 0 <= j < i ==> s[j] != '.'
    invariant result ==> exists k :: 0 <= k < i && s[k] == '.'
  {
    if s[i] == '.' {
      assert s[i] == '.';
      result := true;
      return;
    }
    i := i + 1;
  }
}


method TestContainsDot() {
  // Test case 1: String contains a dot
  var s1 := "hello.world";
  var result := ContainsDot(s1);
  var d1 := no_dot(s1); // Ensure the dot is at index 5
  var d2 := no_dot_recursive(s1);
  assert s1[5] == '.';
  assert s1[..6] == "hello.";
  assert s1[6..] == "world";
  assert s1[0] == 'h';
  // var f1 := find_index(s1, 'h');
  // assert f1 == 0;

//   assert f1 == 0;
//   assert string_slice(s1, 6) == "hello.";
  assert !d2;
  assert result; // Expect true because "." is present

  // Test case 2: String does not contain a dot
  result := ContainsDot("helloworld");
  assert !result; // Expect false because "." is not present

  // Test case 3: Empty string
  result := ContainsDot("");
  assert !result; // Expect false because there are no characters in the string

  // Test case 4: String starts with a dot
  var s2 := ".hello";
  result := ContainsDot(s2);
  assert s2[0] == '.'; // Ensure the dot is at the beginning
  assert result; // Expect true because "." is the first character

  // Test case 5: String ends with a dot
  var s3 := "world.";
  result := ContainsDot(s3);
  assert s3[5] == '.'; // Ensure the dot is at the end
  assert result; // Expect true because "." is the last character

  // Test case 6: String with multiple dots
  var s4 := "..";
  result := ContainsDot(s4);
  assert s4[0] == '.'; // Ensure the first dot is at index 0
  assert result; // Expect true because multiple "." characters exist
}