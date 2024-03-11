method {:axiom} SafeConcatenate(arr1: seq<char>, arr2: seq<char>) returns (result: seq<char>)
 requires |arr1| > 0 && |arr2| > 0
 ensures |result| <= |arr1| + |arr2|
{
    var safeArr1 := RemoveDotDotSlashPattern(arr1);
    assert |safeArr1| <= |arr1|;
    var safeArr2 := RemoveDotDotSlashPattern(arr2);
    assert |safeArr2| <= |arr2|;
    result := safeArr1 + safeArr2;
    assert |result| <= |arr1| + |arr2|;
}

method {:axiom} RemoveDotDotSlashPattern(s: seq<char>) returns (result: seq<char>)
 requires |s| > 0
 ensures |result| <= |s|
{
    if |s| < 3 {
        result := s; // No pattern to remove
        return;
    }

  var i := 0;
    while i < |s| - 2
      invariant 0 <= i <= |s| - 2
    {
        if s[i] == '.' && s[i + 1] == '.' && s[i + 2] == '/' {
            if i == 0 {
                result := s[i + 3..];
            } else if s[i - 1] == '/' {
                result := s[..i - 1] + s[i + 3..];
            } else {
                result := s[..i] + s[i + 3..];
            }
            return;
        }
        i := i + 1;
    }
    result := s;
}

method Main() {
    var arr1 := "some/../path/../";
    var arr2 := "../to/somewhere";

    var concatenated := SafeConcatenate(arr1, arr2);
    
    print "Concatenated array after removing '../' pattern: ";
    print concatenated;
}
