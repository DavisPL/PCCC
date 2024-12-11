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
ensures is_dangerous_path(s) <==> has_path_traversal(s)
{
    has_path_traversal(s) 
}

// predicate has_absolute_path(s: seq<char>)
// ensures has_absolute_path(s) <==> |s| > 0 && (s[0] == '/' || (|s| > 1 && s[1] == ':'))
// {
//     |s| > 0 && (s[0] == '/' || (|s| > 1 && s[1] == ':'))
// }



method PathTraversalTest(){
    var s1: seq<char> := "../../etc/passwd";
    var s2: seq<char> := "/usr/bin/";
    var res1:= has_absolute_path(s1);
    assert !res1;
    var res2:= has_absolute_path(s2);
    assert res2;
    var s3: seq<char> := "%2e%2e/secret/file";
    var res3:= has_path_traversal(s3);
    var s4 := "C:\\Windows\\System32";
    var res4:= has_absolute_path(s4);
    var s5 := "random/path";
    var res5:= has_absolute_path(s5);
    var s6 := "/var/../secret/file";
    var res6:= has_absolute_path(s6);
    assert !res6;

  var paths: seq<seq<char>> := [
      "../etc/passwd",
      "/usr/bin/",
      "%2e%2e/secret/file",
      "C:\\Windows\\System32",
      "random/path"
    ];

    var i := 0;
    while i < |paths| 
    invariant 0 <= i <= |paths|
    decreases |paths| - i
    {
        if is_dangerous_path(paths[i]) {
            print "Dangerous Path Detected: ";
        } else {
            print "Safe Path: ";
        }
        print paths[i] + "\n";
        i := i + 1;
    }
}

