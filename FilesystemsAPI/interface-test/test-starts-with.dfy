
// Helper method: Check if string starts with prefix
method StartsWith(s: string, prefix: string) returns (result: bool)
requires |prefix| > 0
requires |s| > 0
ensures result <==> |s| >= |prefix| && s[..|prefix|] == prefix
ensures !result <==> |s| < |prefix| || s[..|prefix|] != prefix

{
    if |s| < |prefix| {
        result := false;
    } else {
        result := s[..|prefix|] == prefix;
    }
}

method TestStartsWith() {
    var dir := "/usr/bin/python";
    var prefix := "/usr";
    var res := StartsWith(dir, prefix);
    assert res;
    var dir2 := "/usr/bin/python";
    var prefix2 := "/home";
    var res2 := StartsWith(dir2, prefix2);
    // assert dir2[..1] == "/";
    assert dir2[..5] == "/usr/"; //Comment me! Without this line the asssertion in line 27 will fail
    assert !res2;
    var dir3 := "/usr/bin/python";
    var prefix3 := "/var";
    var res3 := StartsWith(dir3, prefix3);
    assert !res3;
    var result := StartsWith("hello world", "hello");
    assert result;
    var result2 := StartsWith("hello world", "world");
    assert !result2;

}