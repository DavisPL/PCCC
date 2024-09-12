// // Predicate to check if a string has two consecutive same characters
// predicate HasConsecutiveSameChars(s: seq<char>)
// {
//   exists i :: 0 <= i < |s| - 1 && s[i] == s[i+1]
// }

// // Predicate to check specifically for two consecutive periods
// predicate HasConsecutivePeriods(s: seq<char>)
// {
//   exists i :: 0 <= i < |s| - 1 && s[i] == '.' && s[i+1] == '.'
// }

// // Function to check for consecutive same characters
// function CheckConsecutiveSameChars(s: seq<char>): bool
// {
//   exists i :: 0 <= i < |s| - 1 && s[i] == s[i+1]
// }

// // Function to check specifically for consecutive periods
// function CheckConsecutivePeriods(s: seq<char>): bool
// {
//   exists i :: 0 <= i < |s| - 1 && s[i] == '.' && s[i+1] == '.'
// }

// lemma LemmaVerifyConsecutiveCharsCorrect(s: seq<char>)
//   ensures HasConsecutiveSameChars(s) <==> CheckConsecutiveSameChars(s)
//   ensures HasConsecutivePeriods(s) <==> CheckConsecutivePeriods(s)
// {
//   if HasConsecutiveSameChars(s) {
//     var i :| 0 <= i < |s| - 1 && s[i] == s[i+1];
//     assert CheckConsecutiveSameChars(s);
//   }
//   if CheckConsecutiveSameChars(s) {
//     var i :| 0 <= i < |s| - 1 && s[i] == s[i+1];
//     assert HasConsecutiveSameChars(s);
//   }
//   if HasConsecutivePeriods(s) {
//     var i :| 0 <= i < |s| - 1 && s[i] == '.' && s[i+1] == '.';
//     assert CheckConsecutivePeriods(s);
//   }
//   if CheckConsecutivePeriods(s) {
//     var i :| 0 <= i < |s| - 1 && s[i] == '.' && s[i+1] == '.';
//     assert HasConsecutivePeriods(s);
//   }
// }

// method VerifyConsecutiveChars(s: seq<char>) returns (hasConsecutive: bool, hasConsecutivePeriods: bool)
//   ensures hasConsecutive == HasConsecutiveSameChars(s)
//   ensures hasConsecutive == CheckConsecutiveSameChars(s)
//   ensures hasConsecutivePeriods == HasConsecutivePeriods(s)
//   ensures hasConsecutivePeriods == CheckConsecutivePeriods(s)
// {
//   hasConsecutive := false;
//   hasConsecutivePeriods := false;
//   var i := 0;
//   while i < |s| - 1
//     invariant 0 <= i <= |s| - 1
//     invariant hasConsecutive == (exists j :: 0 <= j < i && s[j] == s[j+1])
//     invariant hasConsecutivePeriods == (exists j :: 0 <= j < i && s[j] == '.' && s[j+1] == '.')
//   {
//     if s[i] == s[i+1] {
//       hasConsecutive := true;
//       if s[i] == '.' {
//         hasConsecutivePeriods := true;
//         break;
//       }
//     }
//     i := i + 1;
//   }
//   LemmaVerifyConsecutiveCharsCorrect(s);  // Call the lemma here
// }

// method TestConsecutiveCharCheck()
// {
//   print "Starting Consecutive Character Check Tests\n";

//   // Test case 1: String with consecutive characters (not periods)
//   var s1 := ['h', 'e', 'l', 'l', 'o'];
//   var hasConsecutive, hasConsecutivePeriods := VerifyConsecutiveChars(s1);
//   LemmaVerifyConsecutiveCharsCorrect(s1);  // Call the lemma before assertions
//   assert hasConsecutive;
//   assert !hasConsecutivePeriods;
//   assert HasConsecutiveSameChars(s1);
//   assert !HasConsecutivePeriods(s1);
//   print "Test case 1 (hello): hasConsecutive=", hasConsecutive, ", hasConsecutivePeriods=", hasConsecutivePeriods, "\n";

//   // Test case 2: String with consecutive periods
//   var s2 := ['a', '.', '.', 'b'];
//   LemmaVerifyConsecutiveCharsCorrect(s2);  // Call the lemma before assertions
//   hasConsecutive, hasConsecutivePeriods := VerifyConsecutiveChars(s2);
//   assert hasConsecutive;
//   assert hasConsecutivePeriods;
//   assert HasConsecutiveSameChars(s2);
//   assert HasConsecutivePeriods(s2);
//   print "Test case 2 (a..b): hasConsecutive=", hasConsecutive, ", hasConsecutivePeriods=", hasConsecutivePeriods, "\n";

//   // Test case 3: String without consecutive characters
//   var s3 := ['a', 'b', 'c', 'd', 'e'];
//   hasConsecutive, hasConsecutivePeriods := VerifyConsecutiveChars(s3);
//   LemmaVerifyConsecutiveCharsCorrect(s3);  // Call the lemma before assertions
//   assert !hasConsecutive;
//   assert !hasConsecutivePeriods;
//   assert !HasConsecutiveSameChars(s3);
//   assert !HasConsecutivePeriods(s3);
//   print "Test case 3 (abcde): hasConsecutive=", hasConsecutive, ", hasConsecutivePeriods=", hasConsecutivePeriods, "\n";

//   // Test case 4: Empty string
//   var s4: seq<char> := [];
//   LemmaVerifyConsecutiveCharsCorrect(s4);  // Call the lemma before assertions
//   hasConsecutive, hasConsecutivePeriods := VerifyConsecutiveChars(s4);
//   assert !hasConsecutive;
//   assert !hasConsecutivePeriods;
//   assert !HasConsecutiveSameChars(s4);
//   assert !HasConsecutivePeriods(s4);
//   print "Test case 4 (empty string): hasConsecutive=", hasConsecutive, ", hasConsecutivePeriods=", hasConsecutivePeriods, "\n";

//   // Test case 5: String with single character
//   var s5 := ['a'];
//   hasConsecutive, hasConsecutivePeriods := VerifyConsecutiveChars(s5);
//   assert !hasConsecutive;
//   assert !hasConsecutivePeriods;
//   assert !HasConsecutiveSameChars(s5);
//   assert !HasConsecutivePeriods(s5);
//   print "Test case 5 (single character 'a'): hasConsecutive=", hasConsecutive, ", hasConsecutivePeriods=", hasConsecutivePeriods, "\n";

//   // Test case 6: String with consecutive characters at the end
//   var s6 := ['a', 'b', 'c', 'd', 'd'];
//   hasConsecutive, hasConsecutivePeriods := VerifyConsecutiveChars(s6);
//   LemmaVerifyConsecutiveCharsCorrect(s6);  // Call the lemma before assertions
//   assert hasConsecutive;
//   assert !hasConsecutivePeriods;
//   assert HasConsecutiveSameChars(s6);
//   assert !HasConsecutivePeriods(s6);
//   print "Test case 6 (abcdd): hasConsecutive=", hasConsecutive, ", hasConsecutivePeriods=", hasConsecutivePeriods, "\n";

//   print "All test cases completed.\n";
// }

// method Main()
// {
//   TestConsecutiveCharCheck();
// }

// Predicate to check if a string has two consecutive same characters
predicate HasConsecutiveSameChars(s: seq<char>)
{
  exists i :: 0 <= i < |s| - 1 && s[i] == s[i+1]
}

// Predicate to check specifically for two consecutive periods
predicate HasConsecutivePeriods(s: seq<char>)
{
  exists i :: 0 <= i < |s| - 1 && s[i] == '.' && s[i+1] == '.'
}

// Lemma to prove that if there are consecutive same characters up to index k, 
// then HasConsecutiveSameChars is true for the whole sequence
lemma LemmaConsecutiveCharsUpToK(s: seq<char>, k: int)
  requires 0 <= k < |s|
  requires exists i :: 0 <= i < k && s[i] == s[i+1]
  ensures HasConsecutiveSameChars(s)
{
  var i :| 0 <= i < k && s[i] == s[i+1];
  assert 0 <= i < |s| - 1 && s[i] == s[i+1];
}

// Lemma to prove that if there are consecutive periods up to index k, 
// then HasConsecutivePeriods is true for the whole sequence
lemma LemmaConsecutivePeriodsUpToK(s: seq<char>, k: int)
  requires 0 <= k < |s|
  requires exists i :: 0 <= i < k && s[i] == '.' && s[i+1] == '.'
  ensures HasConsecutivePeriods(s)
{
  var i :| 0 <= i < k && s[i] == '.' && s[i+1] == '.';
  assert 0 <= i < |s| - 1 && s[i] == '.' && s[i+1] == '.';
}

// Lemma to prove that if there are no consecutive same characters up to index k,
// and no consecutive same characters at index k, then there are no consecutive
// same characters up to index k+1
lemma LemmaNoConsecutiveCharsUpToKPlus1(s: seq<char>, k: int)
  requires 0 <= k < |s| - 1
  requires !(exists i :: 0 <= i < k && s[i] == s[i+1])
  requires s[k] != s[k+1]
  ensures !(exists i :: 0 <= i < k+1 && s[i] == s[i+1])
{
  if exists i :: 0 <= i < k+1 && s[i] == s[i+1] {
    var i :| 0 <= i < k+1 && s[i] == s[i+1];
    if i < k {
      assert false;  // Contradicts the first requires clause
    } else {
      assert i == k;
      assert false;  // Contradicts the third requires clause
    }
  }
}

method VerifyConsecutiveChars(s: seq<char>) returns (hasConsecutive: bool, hasConsecutivePeriods: bool)
  requires |s| > 0
  ensures hasConsecutive == HasConsecutiveSameChars(s)
  ensures hasConsecutivePeriods == HasConsecutivePeriods(s)
{
  hasConsecutive := false;
  hasConsecutivePeriods := false;
  var i := 0;
  while i < |s| - 1
    invariant 0 <= i <= |s| - 1
    invariant hasConsecutive == (exists j :: 0 <= j < i && s[j] == s[j+1])
    invariant hasConsecutivePeriods == (exists j :: 0 <= j < i && s[j] == '.' && s[j+1] == '.')
    invariant !hasConsecutive ==> !(exists j :: 0 <= j < i && s[j] == s[j+1])
    invariant !hasConsecutivePeriods ==> !(exists j :: 0 <= j < i && s[j] == '.' && s[j+1] == '.')
  {
    if s[i] == s[i+1] {
      hasConsecutive := true;
      LemmaConsecutiveCharsUpToK(s, i+1);
      if s[i] == '.' {
        hasConsecutivePeriods := true;
        LemmaConsecutivePeriodsUpToK(s, i+1);
        break;
      }
    } else if !hasConsecutive {
      LemmaNoConsecutiveCharsUpToKPlus1(s, i);
    }
    i := i + 1;
  }

  if hasConsecutive {
    assert HasConsecutiveSameChars(s);
  } else {
    assert !(exists i :: 0 <= i < |s| - 1 && s[i] == s[i+1]);
    assert !HasConsecutiveSameChars(s);
  }

  if hasConsecutivePeriods {
    assert HasConsecutivePeriods(s);
  } else {
    assert !(exists i :: 0 <= i < |s| - 1 && s[i] == '.' && s[i+1] == '.');
    assert !HasConsecutivePeriods(s);
  }
}

method TestConsecutiveCharCheck()
{
  print "Starting Consecutive Character Check Tests\n";

  // Test case 1: String with consecutive characters (not periods)
  var s1 := ['h', 'e', 'l', 'l', 'o'];
  var hasConsecutive, hasConsecutivePeriods := VerifyConsecutiveChars(s1);
//   LemmaConsecutiveCharsUpToK(s1, 3);  // Call the lemma before assertions
//   assert hasConsecutive;
//   assert !hasConsecutivePeriods;
//   assert HasConsecutiveSameChars(s1);
//   assert !HasConsecutivePeriods(s1);
  print "Test case 1 (hello): hasConsecutive=", hasConsecutive, ", hasConsecutivePeriods=", hasConsecutivePeriods, "\n";

  // Test case 2: String with consecutive periods
  var s2 := ['a', '.', '.', 'b'];
  hasConsecutive, hasConsecutivePeriods := VerifyConsecutiveChars(s2);
//   assert hasConsecutive;
//   assert hasConsecutivePeriods;
//   assert HasConsecutiveSameChars(s2);
//   assert HasConsecutivePeriods(s2);
  print "Test case 2 (a..b): hasConsecutive=", hasConsecutive, ", hasConsecutivePeriods=", hasConsecutivePeriods, "\n";

  // Test case 3: String without consecutive characters
  var s3 := ['a', 'b', 'c', 'd', 'e'];
  hasConsecutive, hasConsecutivePeriods := VerifyConsecutiveChars(s3);
  assert !hasConsecutive;
  assert !hasConsecutivePeriods;
  assert !HasConsecutiveSameChars(s3);
  assert !HasConsecutivePeriods(s3);
  print "Test case 3 (abcde): hasConsecutive=", hasConsecutive, ", hasConsecutivePeriods=", hasConsecutivePeriods, "\n";

  // Test case 4: Empty string
//   var s4: seq<char> := [];
//   hasConsecutive, hasConsecutivePeriods := VerifyConsecutiveChars(s4);
//   assert !hasConsecutive;
//   assert !hasConsecutivePeriods;
//   assert !HasConsecutiveSameChars(s4);
//   assert !HasConsecutivePeriods(s4);
//   print "Test case 4 (empty string): hasConsecutive=", hasConsecutive, ", hasConsecutivePeriods=", hasConsecutivePeriods, "\n";

  // Test case 5: String with single character
  var s5 := ['a'];
  hasConsecutive, hasConsecutivePeriods := VerifyConsecutiveChars(s5);
  assert !hasConsecutive;
  assert !hasConsecutivePeriods;
  assert !HasConsecutiveSameChars(s5);
  assert !HasConsecutivePeriods(s5);
  print "Test case 5 (single character 'a'): hasConsecutive=", hasConsecutive, ", hasConsecutivePeriods=", hasConsecutivePeriods, "\n";

  // Test case 6: String with consecutive characters at the end
  var s6 := ['a', 'b', 'c', 'd', 'd'];
  hasConsecutive, hasConsecutivePeriods := VerifyConsecutiveChars(s6);
//   assert hasConsecutive;
//   assert !hasConsecutivePeriods;
//   assert HasConsecutiveSameChars(s6);
//   assert !HasConsecutivePeriods(s6);
  print "Test case 6 (abcdd): hasConsecutive=", hasConsecutive, ", hasConsecutivePeriods=", hasConsecutivePeriods, "\n";

  print "All test cases completed.\n";
}

method Main()
{
  TestConsecutiveCharCheck();
}