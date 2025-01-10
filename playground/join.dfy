// method LoopOverSequence(words: seq<string>)
//   requires |words| > 0  // Ensure sequence is non-empty
// {
//   var i := 0;  // Start index
//   while i < |words|  // Loop over sequence based on length
//     invariant 0 <= i <= |words|  // Invariant to keep index within bounds
//     decreases |words| - i  // Ensures the loop terminates
//   {
//     print "Word ", words[i], "\n";  // Access element at index `i`
//     i := i + 1;  // Increment index
//   }
// }

// method Main() {
//   var exampleSeq := ["Hello", "Dafny", "World"];
//    LoopOverSequence(exampleSeq);
// }

method JoinWordsWithChar(words: seq<string>, appendChar: string) returns (result: string)
  requires |words| > 0  // Ensure sequence is non-empty
  requires |appendChar| == 1  // Ensure the append character is a single character
  ensures |result| >= |words|  // The result should at least have the same number of characters as words count
{
  var i := 0;
  var combinedString := "";  // Initialize an empty string to store the result

  while i < |words|
    invariant 0 <= i <= |words|  // Keep index within bounds
    invariant |combinedString| >= i  // The length of the result string grows as we add words
    decreases |words| - i  // Ensures termination
  {
    combinedString := combinedString + words[i] + appendChar;  // Add word with the appended character
    i := i + 1;  // Increment index
  }

  return combinedString;  // Return the concatenated string
}

method Main() {
  var exampleSeq := ["Hello", "Dafny", "World"];
  var charToAppend := "/";  // Specify the character to append

  var result := JoinWordsWithChar(exampleSeq, charToAppend);
  print "Joined string: ", result, "\n";
}