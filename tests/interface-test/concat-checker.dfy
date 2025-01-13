// Function to concatenate two non-empty strings
function ConcatStrings(s1: string, s2: string): string
  requires s1 != "" && s2 != ""
{
  s1 + s2
}

// Lemma to verify properties of ConcatStrings
lemma ConcatStringsProperties(s1: string, s2: string)
  requires s1 != "" && s2 != ""
  ensures ConcatStrings(s1, s2) == s1 + s2
  ensures |ConcatStrings(s1, s2)| == |s1| + |s2|
  ensures forall i :: 0 <= i < |s1| ==> ConcatStrings(s1, s2)[i] == s1[i]
  ensures forall i :: 0 <= i < |s2| ==> ConcatStrings(s1, s2)[|s1| + i] == s2[i]
{
  // The body of the lemma is empty because Dafny can prove these properties automatically
}

// Test method for ConcatStrings function
method TestConcatStrings()
{
  // Test case 1: Basic concatenation of non-empty strings
  var result1 := ConcatStrings("Hello, ", "World!");
  assert result1 == "Hello, World!";
  
  // Test case 2: Concatenation with numbers
  var result2 := ConcatStrings("Count: ", "123");
  assert result2 == "Count: 123";

  // Test case 3: Verify length of result
  var s1 := "Dafny";
  var s2 := "Verification";
  var result3 := ConcatStrings(s1, s2);
  assert |result3| == |s1| + |s2|;

  // The following lines would cause Dafny to report errors at compile-time:
  // var invalidResult1 := ConcatStrings("", "Not Empty");  // Fails precondition
  // var invalidResult2 := ConcatStrings("Not Empty", "");  // Fails precondition
  // var invalidResult3 := ConcatStrings("", "");           // Fails precondition

  print "All ConcatStrings tests passed successfully!\n";
}

method {:main} Main()
{
  TestConcatStrings();
}