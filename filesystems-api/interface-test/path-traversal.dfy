predicate has_path_traversal(s: seq<char>)
ensures has_path_traversal(s) <==> exists i :: 0 <= i < |s| && is_traversal_pattern(s, i)
{
    exists i :: 0 <= i < |s| && is_traversal_pattern(s, i)
}

predicate is_traversal_pattern(s: seq<char>, i: int)
requires 0 <= i < |s|
{
    (i + 2 < |s| && s[i] == '.' && s[i+1] == '.' && (s[i+2] == '/' || s[i+2] == '\\')) ||
    (i + 5 < |s| && s[i..i+6] == ['%', '2', 'e', '%', '2', 'e']) ||
    (i + 8 < |s| && s[i..i+9] == ['%', '2', '5', '2', 'e', '%', '2', '5', '2', 'e']) ||
    (i > 0 && s[i-1] == '/' && i + 2 < |s| && s[i] == '.' && s[i+1] == '.' && s[i+2] == '.')
}

predicate is_dangerous_path(s: seq<char>)
ensures is_dangerous_path(s) <==> has_path_traversal(s) || has_absolute_path(s)
{
    has_path_traversal(s) || has_absolute_path(s)
}

predicate has_absolute_path(s: seq<char>)
ensures has_absolute_path(s) <==> |s| > 0 && (s[0] == '/' || (|s| > 1 && s[1] == ':'))
{
    |s| > 0 && (s[0] == '/' || (|s| > 1 && s[1] == ':'))
}

method PathTraversalTest(){
  var s1: seq<char> := "../../etc/passwd";
  var s2: seq<char> := "/usr/bin/";
  var res1:= has_absolute_path(s1);
  assert !res1;
  var res2:= has_absolute_path(s2);
  assert res2;
}

