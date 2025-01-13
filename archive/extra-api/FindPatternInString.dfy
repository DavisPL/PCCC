// function FindPattern(str: seq<char>, pattern: seq<char>): int
//     requires |pattern| > 0  // Ensure we're not searching for an empty pattern
//     ensures -1 <= FindPattern(str, pattern) < |str|  // Ensure the result is within valid bounds

// // Step 2: Implement the core algorithm
// {
//     if |str| < |pattern| then 
//         -1  // Pattern can't be in the string if string is shorter
//     else if str[..|pattern|] == pattern then 
//         0  // Pattern found at the beginning
//     else if |str| == |pattern| then 
//         -1  // Pattern not found and no more characters to check
//     else 
//         var subResult := FindPattern(str[1..], pattern);
//         if subResult == -1 then 
//             -1  // Pattern not found in substring
//         else 
//             1 + subResult  // Pattern found in substring, adjust index
// }

// Helper lemma to prove a property about a specific index
lemma SpecificIndexProperty(str: seq<char>, pattern: seq<char>, i: int)
    requires |pattern| > 0 && |str| > |pattern|
    requires forall j :: 0 <= j <= |str| - |pattern| ==> str[j..j+|pattern|] != pattern
    requires 1 <= i <= |str| - |pattern|
    ensures str[i..i+|pattern|] != pattern
{
    // The index i in str corresponds to index i-1 in str[1..]
    assert str[i..] == str[1..][i-1..];
    assert str[i..i+|pattern|] == str[1..][i-1..i-1+|pattern|];
    
    // Use the precondition with j = i
    assert str[i..i+|pattern|] != pattern by {
        assert 0 <= i <= |str| - |pattern|;
        // Instantiate the quantifier in the precondition with i
        assert str[i..i+|pattern|] != pattern;
    }
}



// Helper lemma to prove properties about substring relationships
lemma SubstringRelation(s: seq<char>, start: int, len: int)
    requires 0 <= start <= |s| && 0 <= len <= |s| - start
    ensures s[start..start+len] == s[start..][..len]
{}


lemma SubsequenceNotEqual<T>(s1: seq<T>, s2: seq<T>, x: T)
  requires s1 != s2
  requires |s1| == |s2|
  ensures s1 + [x] != s2
{
  if s1 + [x] == s2 {
    assert false;
  }
}
predicate IsValidSubsequence<T>(s: seq<T>, start: int, len: int)
{
  0 <= start && 0 <= len && start + len <= |s|
}

predicate NotPattern<T(==)>(s: seq<T>, pattern: seq<T>, i: int)
{
  !IsValidSubsequence(s, i, |pattern|) || s[i..i+|pattern|] != pattern
}

lemma PatternStructureIfRepeated<T(==)>(s: seq<T>, pattern: seq<T>, i: int)
  requires |pattern| > 1
  requires IsValidSubsequence(s, i, |pattern|) && IsValidSubsequence(s, i+1, |pattern|)
  requires s[i..i+|pattern|] == pattern && s[i+1..i+1+|pattern|] == pattern
  ensures forall k :: 0 <= k < |pattern| - 1 ==> pattern[k] == pattern[k+1]
{
  forall k | 0 <= k < |pattern| - 1
  ensures pattern[k] == pattern[k+1]
  {
    calc {
      pattern[k];
      == s[i+k];  // Because s[i..i+|pattern|] == pattern
      == s[i+1+k];  // Because s[i+1..i+1+|pattern|] == pattern
      == pattern[k+1];  // Because s[i+1..i+1+|pattern|] == pattern
    }
  }
}

// lemma NotFoundAtNextIndex<T(==)>(s: seq<T>, pattern: seq<T>, i: int)
//   requires |pattern| > 1
//   requires 0 <= i < |s| - |pattern|
//   requires forall j :: 0 <= j <= i ==> NotPattern(s, pattern, j)
//   ensures NotPattern(s, pattern, i+1)
// {
//   if !IsValidSubsequence(s, i+1, |pattern|) {
//     // If the subsequence is not valid, NotPattern is true by definition
//     assert NotPattern(s, pattern, i+1);
//   } else {
//     // The subsequence is valid, so we need to prove s[i+1..i+1+|pattern|] != pattern
//     if s[i+1..i+1+|pattern|] == pattern {
//       // Assume for contradiction that the pattern is found at i+1
//       assert IsValidSubsequence(s, i, |pattern|);  // This follows from the preconditions
//       assert NotPattern(s, pattern, i);  // This follows from the precondition
      
//       // Since NotPattern(s, pattern, i) is true and IsValidSubsequence(s, i, |pattern|) is true,
//       // we know that s[i..i+|pattern|] != pattern
//       assert s[i..i+|pattern|] != pattern;
      
//       // Now we have:
//       // 1. s[i..i+|pattern|] != pattern
//       // 2. s[i+1..i+1+|pattern|] == pattern
//       // These two statements cannot both be true for |pattern| > 1
      
//       // Let's prove this:
//       assert s[i+1..i+1+|pattern|] == pattern;
//       assert s[i..i+|pattern|] != pattern;
      
//       // The following must be true (shifting the indices by 1):
//       assert s[i+1..i+1+|pattern|-1] == pattern[0..|pattern|-1];
      
//       // But this contradicts s[i..i+|pattern|] != pattern, because:
//       assert s[i..i+|pattern|] == s[i..i+1] + s[i+1..i+|pattern|];
//       assert s[i+1..i+|pattern|] == pattern[0..|pattern|-1];
      
//       // For these to be different, s[i] must be different from pattern[|pattern|-1]
//       // But we know s[i+1+|pattern|-1] == pattern[|pattern|-1] from s[i+1..i+1+|pattern|] == pattern
//       // This is impossible for |pattern| > 1
      
//     //   assert false;  // This line should be provable due to the contradiction
//     }
//     // If we didn't enter the if statement, it means s[i+1..i+1+|pattern|] != pattern
//     assert s[i+1..i+1+|pattern|] != pattern;
//     assert NotPattern(s, pattern, i+1);
//   }
// }
// method FindPattern(text: string, pattern: string) returns (occurrences: seq<int>)
//   ensures |pattern| == 0 ==> 
//     |occurrences| == |text| + 1 && forall i :: 0 <= i <= |text| ==> i in occurrences
//   ensures |pattern| > 0 ==>
//     (forall i :: 0 <= i < |occurrences| ==> 
//       0 <= occurrences[i] <= |text| - |pattern| &&
//       text[occurrences[i]..occurrences[i]+|pattern|] == pattern)
//   ensures |pattern| > 0 ==>
//     (forall i :: 0 <= i <= |text| - |pattern| ==>
//       (text[i..i+|pattern|] == pattern) <==> (i in occurrences))
// {
//   if |pattern| == 0 {
//     // If pattern is empty, it matches at every position
//     occurrences := seq(|text| + 1, i => i);
//   } else if |text| < |pattern| {
//     // If pattern is longer than text, no matches are possible
//     occurrences := [];
//   } else {
//     occurrences := [];
//     var i := 0;
//     while i <= |text| - |pattern|
//       invariant 0 <= i <= |text| - |pattern| + 1
//       invariant forall j :: 0 <= j < |occurrences| ==> 
//         0 <= occurrences[j] < i &&
//         text[occurrences[j]..occurrences[j]+|pattern|] == pattern
//       invariant forall j :: 0 <= j < i ==>
//         (text[j..j+|pattern|] == pattern) ==> (j in occurrences)
//     {
//       if text[i..i+|pattern|] == pattern {
//         occurrences := occurrences + [i];
//       }
//       i := i + 1;
//     }
//   }
// }
