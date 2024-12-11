const fileMaxLength := 255
// Predicate to check if a sequence is in a list of sequences
predicate SequenceInList(list: seq<seq<char>>, sub: seq<char>)
{
  exists i :: 0 <= i < |list| && sub == list[i]
}

// Predicate to check if a file is nonsensitive
predicate IsNonsensitiveFile(fileName: seq<char>, nonSensitiveFilesList: seq<seq<char>>)
  requires 0 < |fileName| <= fileMaxLength
{
  SequenceInList(nonSensitiveFilesList, fileName) || fileName in nonSensitiveFilesList
}

// Function to validate if a file is nonsensitive
function ValidateNonsensitiveFileFunc(fileName: seq<char>, nonSensitiveFilesList: seq<seq<char>>): bool
  requires 0 < |fileName| <= fileMaxLength
  ensures ValidateNonsensitiveFileFunc(fileName, nonSensitiveFilesList) == IsNonsensitiveFile(fileName, nonSensitiveFilesList)
{
  SequenceInList(nonSensitiveFilesList, fileName) || fileName in nonSensitiveFilesList
}

// Method that uses the predicate and function (for demonstration purposes)
method ValidateNonsensitiveFile(fileName: seq<char>, nonSensitiveFilesList: seq<seq<char>>) returns (result: bool)
  requires 0 < |fileName| <= fileMaxLength
  ensures result == IsNonsensitiveFile(fileName, nonSensitiveFilesList)
  ensures result == ValidateNonsensitiveFileFunc(fileName, nonSensitiveFilesList)
{
  result := ValidateNonsensitiveFileFunc(fileName, nonSensitiveFilesList);
}


method TestNonsensitiveFileValidation()
{
  var nonSensitiveFilesList: seq<seq<char>> := [
    ['d', 'o', 'c', '.', 't', 'x', 't'],
    ['i', 'm', 'a', 'g', 'e', '.', 'j', 'p', 'g'],
    ['d', 'a', 't', 'a', '.', 'c', 's', 'v']
  ];

  // Test case 1: File in the list
  var fileName1: seq<char> := ['d', 'o', 'c', '.', 't', 'x', 't'];
  var result := ValidateNonsensitiveFile(fileName1, nonSensitiveFilesList);
  assert result;
  assert IsNonsensitiveFile(fileName1, nonSensitiveFilesList);
  assert ValidateNonsensitiveFileFunc(fileName1, nonSensitiveFilesList);
  print "Test case 1 (File in list): ", result, "\n";

  // Test case 2: File not in the list
  var fileName2: seq<char> := ['s', 'e', 'c', 'r', 'e', 't', '.', 'p', 'd', 'f'];
  result := ValidateNonsensitiveFile(fileName2, nonSensitiveFilesList);
  assert !result;
  assert !IsNonsensitiveFile(fileName2, nonSensitiveFilesList);
  assert !ValidateNonsensitiveFileFunc(fileName2, nonSensitiveFilesList);
  print "Test case 2 (File not in list): ", result, "\n";

  // Test case 3: Empty file name (should fail due to requires clause)
  // var fileName3: seq<char> := [];
  // Uncommenting the next line should cause a verification error:
  // result := ValidateNonsensitiveFile(fileName3, nonSensitiveFilesList);

  // Test case 4: File name at max length
  var fileName4: seq<char> := seq(fileMaxLength, i => 'a');
  result := ValidateNonsensitiveFile(fileName4, nonSensitiveFilesList);
  assert !result;
  assert !IsNonsensitiveFile(fileName4, nonSensitiveFilesList);
  assert !ValidateNonsensitiveFileFunc(fileName4, nonSensitiveFilesList);
  print "Test case 4 (File name at max length): ", result, "\n";

  // Test case 5: Empty list of nonsensitive files
  var emptyList: seq<seq<char>> := [];
  result := ValidateNonsensitiveFile(fileName1, emptyList);
  assert !result;
  assert !IsNonsensitiveFile(fileName1, emptyList);
  assert !ValidateNonsensitiveFileFunc(fileName1, emptyList);
  print "Test case 5 (Empty list of nonsensitive files): ", result, "\n";

  print "All test cases completed.\n";
}

method Main()
{
  TestNonsensitiveFileValidation();
}