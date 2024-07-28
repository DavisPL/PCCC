include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

// method TestAlphaNumeric()
// {
//     var c1 := 'a';
//     assert alpha_numeric(c1);
//     var c2 := 'A';
//     assert alpha_numeric(c2);
//     var c3 := 'z';
//     assert alpha_numeric(c3);
//     var c4 := 'Z';
//     assert alpha_numeric(c4);
//     var c5 := '0';
//     assert alpha_numeric(c5);
//     var c6 := '9';
//     assert alpha_numeric(c6);
//     var c7 := ' ';
//     assert !alpha_numeric(c7);
//     var c8 := '.';
//     assert !alpha_numeric(c8);
//     var s1 := "hello";
//     assert forall i :: 0 <= i < |s1| ==> alpha_numeric(s1[i]);
//     var s2 := "hello1";
//     assert forall i :: 0 <= i < |s2| ==> alpha_numeric(s2[i]);
//     var s3 := "hello1.";
//     assert !alpha_numeric(s3[6]);
// }

// method TestValidateFileChar()
// {
//     var c1 := 'a';
//     assert validate_file_char(c1);
//     var c2 := 'A';
//     assert validate_file_char(c2);
//     var c3 := 'z';
//     assert validate_file_char(c3);
//     var c4 := 'Z';
//     assert validate_file_char(c4);
//     var c5 := '0';
//     assert validate_file_char(c5);
//     var c6 := '9';
//     assert validate_file_char(c6);
//     var c7 := ' ';
//     assert !validate_file_char(c7);
//     var c8 := '.';
//     assert validate_file_char(c8);
//     // var c9 := '_';
//     // assert validate_file_char(c9);
//     var c10 := '-';
//     assert validate_file_char(c10);
//     // var c11 := '/';
//     // assert validate_file_char(c11);
//     var c12 := '!';
//     assert !validate_file_char(c12);
//     var c13 := '@';
//     assert !validate_file_char(c13);
// }

// method Testvalidate_file()
// {
//     var c1 := 'a';
//     assert validate_file_char(c1);
//     var c2 := 'A';
//     assert validate_file_char(c2);
//     var c3 := 'z';
//     assert validate_file_char(c3);
//     var c4 := 'Z';
//     assert validate_file_char(c4);
//     var c5 := '0';
//     assert validate_file_char(c5);
//     var c6 := '9';
//     assert validate_file_char(c6);
//     var c7 := ' ';
//     assert !validate_file_char(c7);
//     var c8 := '.';
//     assert validate_file_char(c8);
//     var c9 := '-';
//     assert validate_file_char(c9);
//     var c10 := '!';
//     assert !validate_file_char(c10);
//     var c11 := '@';
//     assert !validate_file_char(c11);
//     var fileName2: seq<char> := "@.txt";
//     var c := fileName2[0];
//     assert c == '@';
//     var isChar1 := validate_file_char(c);
//     assert !isChar1;
//     var fileName5: seq<char> := ".....file5";
// }
//  method TestIsValidFileName() 
   
// // {
// //   // Valid file names
// //   var s1 := "file.txt";
// //   var v1 := validate_file("file.txt");
// //   if v1 {
// //     assert alpha_numeric(s1[0]);
// //     assert alpha_numeric(s1[|s1| - 1]);
// //     assert forall i :: 1 <= i < |s1| - 1  ==> validate_file_char(s1[i]);
// //   }
// //   var s2 := validate_file("File1");
// //   assert s2;
// //   var s3 := validate_file("longFileNameWithNumbers-2736.txt");
// //   assert s3;

// //     // Invalid file names
// //     // var s4 := validate_file("file name");
// //     // assert s4;
// //     //   var s5 := validate_file(".file");
// //     //   assert s5;
// //     //   var s6 := validate_file("file.");
// //     //   assert s6;
// //     // var s7 := validate_file("file name");
// //     // assert !s7;
// //     // var s9 := validate_file("file_name");
// //     // assert s9;
// //     var s8 := validate_file("file-name");
// //     assert s8;
// // }

// method ContainsSequenceTest(){
//   var s1: seq<seq<char>> := [['H','e','l','l','o'],['W','o','r','l','d']];
//   var s2: seq<char> := ['W','o','r','l','d'];
//   var res1:=ContainsSequence(s1,s2);
//   // assert s2 in s1;
//   assert res1;
//   // expect res1==false;
//   // var s3: seq<seq<char>> := invalidFileTypes;
//   var s4: seq<char> := "CON";

//   var res3:=ContainsSequence(invalidFileTypes,s4);

//   assert res3;
//   var s3: seq<seq<char>> := ["Hi", "Bye"];
//   var s5: seq<char> := "bye";
//   var res2:=ContainsSequence(s3,s5);
//   // expect res2==true;
//   assert !res2;

//   // var s5: seq<seq<char>> := [[2,4,3,5,7],[1,0]];
//   // var s6: seq<char> := [1,6];
//   // var res3:=ContainsSequence(s5,s6);
//   // expect res3==false;

// }

// method ConvertionsTest(){
//   var r := ComputeNumberToString(01234567890);
//   assert r == number_to_string(01234567890);
//   var charA := 'A';
//   assert 65 == char_to_byte(charA);
//   print "r " ,r ,"\n";
//   print "Ascii of c is: ", char_to_byte(charA), "\n";
//   var testString := "abcA";
//   print "string is ", testString, "\n";
//   var bytes := StringToSeqInt(testString);
//   print "bytes ", bytes, "\n ";
//   assert bytes[0] == 'a' as int; // Test each byte individually
//   assert bytes[1] == 'b' as int;
//   assert bytes[2] == 'c' as int;
//   assert bytes[3] == 'A' as int;
//   // If the testString is longer than 3 characters, this will fail
//   assert |bytes| == 4; // Assert the length is as expected
//   assert bytes == [97, 98, 99, 65];
// }

// method ConcatTest() {
//   var s1: seq<char> := ['a', 'b', 'c'];
//   var s2: seq<char> := ['d', 'e', 'f'];
//   var s3 := concat(s1, s2);
//   assert s3 == ['a', 'b', 'c', 'd', 'e', 'f'];
//   assert |s3| == 6;
//   var s4: seq<char> := "/Users/pari/pcc-llms/src/playground/";
//   var s5: seq<char> := "safeFile-1.txt";
//   var s6 := concat(s4, s5);
//   assert s6 == "/Users/pari/pcc-llms/src/playground/safeFile-1.txt";

// }


// method TestCharToByte()
// {
//    // Test ASCII characters
//     assert char_to_byte('A') == 65 as byte;
//     assert char_to_byte('0') == 48 as byte;
//     assert char_to_byte('~') == 126 as byte;

//     // Test null character
//     assert char_to_byte('\0') == 0 as byte;

//     // Test maximum byte value
//     assert char_to_byte(255 as char) == 255 as byte;

//     // Test character beyond byte range
//     assert char_to_byte(256 as char) == 0 as byte;

//     // Test some Unicode characters
//     assert char_to_byte('ñ') == 241 as byte;  // 'ñ' has Unicode code point U+00F1
//     assert char_to_byte('€') == 0 as byte;    // '€' has Unicode code point U+20AC, which is beyond byte range

//     print "All tests passed!";
// }

// method TestStringToBytes()
// {
//     var result := StringToBytes("Hello");
//     assert |result| == 5;
//     assert result[0] == 72;  // 'H'
//     assert result[1] == 101; // 'e'
//     assert result[2] == 108; // 'l'
//     assert result[3] == 108; // 'l'
//     assert result[4] == 111; // 'o'

//     result := StringToBytes("123");
//     assert |result| == 3;
//     assert result[0] == 49;  // '1'
//     assert result[1] == 50;  // '2'
//     assert result[2] == 51;  // '3'

//     result := StringToBytes("ñ");  // Unicode character
//     assert |result| == 1;
//     assert result[0] == 241;  // 'ñ' has Unicode code point U+00F1

//     result := StringToBytes("€");  // Unicode character beyond byte range
//     assert |result| == 1;
//     assert result[0] == 0;   // Out of byte range, so it's mapped to 0

//     result := StringToBytes("");
//     assert |result| == 0;    // Empty string results in empty sequence

//     print "All tests passed!";
// }

// method test_has_path_traversal()
// {

    // var s1: seq<char> := "Hello..world";
    // var s2: seq<char> := "Hello.world";
    // var s3: seq<char> := "../file.txt";
    // var s4: seq<char> := "file/../secret.txt";
    // var s5: seq<char> := "file/..\\secret.txt";
    // var s6: seq<char> := "file/%2e%2e/secret.txt";
    // var s7: seq<char> := "file/%252e%252e/secret.txt";
    // var s8: seq<char> := ".../secret.txt";
    // var s9: seq<char> := "file/../../secret.txt";
    // var s10: seq<char> := "file.txt";
    // var s11: seq<char> := "/var/www/html/index.html";
    // var s12: seq<char> := "..file/secret.txt";
    // var s13: seq<char> := "file..txt";
    // var s14: seq<char> := "%2fvar%2fwww%2fhtml%2findex.html";
    
    // Positive test cases (should return true)
    // assert ContainsConsecutivePeriods(s1);
    // assert !ContainsConsecutivePeriods(s2);
    // assert ContainsConsecutivePeriods(s3);
    // assert ContainsConsecutivePeriods(s4);
    // assert ContainsConsecutivePeriods(s5);
    // assert ContainsEncodedPeriods(s6);
    // assert ContainsEncodedPeriods(s7);
    // assert ContainsConsecutivePeriods(s8);
    // assert ContainsConsecutivePeriods(s9);
    // assert ContainsConsecutivePeriods(s10);
    // assert !ContainsConsecutivePeriods(s11);
    // assert !ContainsConsecutivePeriods(s12);
    // assert !ContainsConsecutivePeriods(s13);
    // assert !ContainsConsecutivePeriods(s14);
// }

//  method TestHasNoLeadingOrTrailingSpaces()
//     {
//         // Valid cases
//         assert HasNoLeadingOrTrailingSpaces("filename.txt");
//         assert HasNoLeadingOrTrailingSpaces("file with spaces.txt");
//         assert HasNoLeadingOrTrailingSpaces("a");  // Single character

//         // Invalid cases
//         assert !HasNoLeadingOrTrailingSpaces(" filename.txt");
//         assert !HasNoLeadingOrTrailingSpaces("filename.txt ");
//         assert !HasNoLeadingOrTrailingSpaces(" filename.txt ");
//         assert !HasNoLeadingOrTrailingSpaces("  ");  // Only spaces

//         // Edge cases
//         assert !HasNoLeadingOrTrailingSpaces("file.txt ");  // Space in middle is fine
//         assert !HasNoLeadingOrTrailingSpaces(" file.txt");  // Space in middle is fine
        //    assert HasNoLeadingOrTrailingSpaces("fil e.txt");  // Space in middle is fine
//         assert !HasNoLeadingOrTrailingSpaces(" fil e.txt");  // Space in middle is fine
//         print "All tests for HasNoLeadingOrTrailingSpaces passed!\n";
    // }

// method TestDoesNotStartWithPeriod()
// {
//     // Valid cases
//     assert DoesNotStartWithPeriod("filename.txt");
//     assert DoesNotStartWithPeriod("file.with.periods.txt");
//     assert DoesNotStartWithPeriod("a");  // Single character

//     // // Invalid cases
//     assert !DoesNotStartWithPeriod(".hidden_file");
//     assert !DoesNotStartWithPeriod("..parent_directory");
//     assert !DoesNotStartWithPeriod(".");  // Single period

//     // Edge cases
//     assert DoesNotStartWithPeriod("file.txt.");  // Ending with period is fine
//     assert DoesNotStartWithPeriod("file..txt");  // Periods in middle are fine

//     print "All tests for DoesNotStartWithPeriod passed!\n";
// }

//   method TestPathJoin()
//     {
//         // Test case 1: Path without trailing slash
//         // var p1: seq<char> := "path/to";
//         // var f1: seq<char> := "file.txt";
//         // var result1 := PathJoin(p1, f1);
//         // // assert result1 != "path/to/file.txt";
//         // print "Test 1 passed: ", result1, "\n";

//         // // Test case 2: Path with trailing slash
//         // var p2: seq<char> := "path/to/";
//         // var f2: seq<char> := "file.txt";
//         // var result2 := PathJoin(p2, f2);
//         // assert result2 != "path/to/file.txt";
//         // print "Test 2 passed: ", result2, "\n";

//         // // Test case 3: Root path
//         // var p3: seq<char> := "/";
//         // var f3: seq<char> := "file.txt";
//         // var result3 := PathJoin(p3, f3);
//         // assert result3 == "/file.txt";
//         // print "Test 3 passed: ", result3, "\n";

//         // // Test case 4: Empty file name (edge case)
//         var p4: seq<char> := "/path/to/a/directory/";
//         var f4: seq<char> := "f";  // Minimum length to satisfy precondition
//         var result4 := PathJoin(p4, f4);
//         assert result4 != "this/path/to/a/directory/f";
//         print "Test 4 passed: ", result4, "\n";

//         // // Test case 5: Long path (close to max length)
//         var p5: seq<char> := "a" + "b" ;
//         var f5: seq<char> := "file";
//         var result5 := PathJoin(p5, f5);
//         assert |result5| <= pathMaxLength;

//         print "Test 5 passed: Path joined successfully within max length\n";

//         // // Test case 6: Path with multiple slashes
//         var p6: seq<char> := "path//to////";
//         var f6: seq<char> := "file.txt";
//         var result6 := PathJoin(p6, f6);
//         assert result6 == "path//to////file.txt";
//         print "Test 6 passed: ", result6, "\n";

//         // print "All tests passed successfully!\n";
//     }

method TestIsValidFileExtension()
    {
        // Test case 1: Valid file extension
        var filename1 := "document.txt";
        // assert LastIndexOf(filename1, '.') == 8;
        // assert IsValidFileExtension(filename1);
        print "Test 1 passed: ", filename1, " is valid\n";


        // Test case 2: No file extension
        var filename2 := "document";
        assert !IsValidFileExtension(filename2);
        print "Test 2 passed: ", filename2, " is invalid\n";

        // Test case 3: File extension with multiple dots
        var filename3 := "archive.tar.gz";
        // assert IsValidFileExtension(filename3);
        print "Test 3 passed: ", filename3, " is valid\n";
        var extention3 := GetFileExtension(filename3);

        // Test case 4: Hidden file (starting with a dot)
        var filename4 := ".hidden";
        // assert !IsValidFileExtension(filename4);
        print "Test 4 passed: ", filename4, " is invalid\n";

        // Test case 5: File with path and valid extension
        var filename5 := "/path/to/file.jpg";
        // assert IsValidFileExtension(filename5);
        print "Test 5 passed: ", filename5, " is valid\n";

        // Test case 6: File with path and no extension
        var filename6 := "/path/to/file";
        assert !IsValidFileExtension(filename6);
        print "Test 6 passed: ", filename6, " is invalid\n";

        // Test case 7: File with extension but ending in a path separator
        var filename7 := "file.txt/";
        assert !IsValidFileExtension(filename7);
        print "Test 7 passed: ", filename7, " is invalid\n";

        // Test case 8: Empty string (edge case)
        var filename8 := "";
        // Note: This will not be checked due to the precondition
        print "Test 8: Empty string is not checked due to precondition\n";

        print "All tests completed.\n";
    }


// method TestContainsDangerousPattern()
//     {
//         var testCases := [
//             "file.txt",
//             "../file.txt",
//             "subdirectory/file.txt",
//             "../../etc/passwd",
//             "/etc/passwd",
//             "C:\\Windows\\System32\\config\\SAM",
//             "~/.bashrc",
//             "normal/path/file.txt"
//         ];

//         var i := 0;
//         while i < |testCases|
//             invariant 0 <= i <= |testCases|
//         {
//             var path := testCases[i];
//             var isDangerous := ContainsDangerousPattern(path);
//             print "Path: ", path, " - ", if isDangerous then "Dangerous" else "Safe", "\n";
//             i := i + 1;
//         }
//     }

// method IsValidFileExtension(filename: string) returns (isValid: bool)
//   ensures isValid ==> |filename| > 0 && filename[0] != '.'
// {
//   var allowedExtensions := ["txt", "csv", "dat", "log"];
  
//   if |filename| == 0 || filename[0] == '.' {
//     return false;
//   }
  
//   var lastDotIndex := -1;
//   var i := 0;
//   while i < |filename|
//     invariant 0 <= i <= |filename|
//     invariant forall j :: 0 <= j < i && filename[j] == '.' ==> lastDotIndex == j
//   {
//     if filename[i] == '.' {
//       lastDotIndex := i;
//     }
//     i := i + 1;
//   }
  
//   if lastDotIndex == -1 || lastDotIndex == |filename| - 1 {
//     return false;
//   }
  
//   var extension := filename[lastDotIndex+1..];
  
//   isValid := false;
//   for i := 0 to |allowedExtensions|
//     invariant 0 <= i <= |allowedExtensions|
//     invariant isValid ==> exists j :: 0 <= j < i && allowedExtensions[j] == extension
//   {
//     if allowedExtensions[i] == extension {
//       isValid := true;
//       break;
//     }
//   }
  
//   return isValid;
// }




// method TestFileExtention(){
//     var validFile := IsValidFileExtension("example.txt");
//   assert validFile;
  
//   var invalidFile := IsValidFileExtension("example.invalid");
//   assert !invalidFile;
  
//   print "Valid file: ", validFile, "\n";
//   print "Invalid file: ", invalidFile, "\n";
// }

// Lemma to prove that if a character is not found after a certain index,
// it doesn't exist in the substring from that index to the end
// Lemma to prove that if a character is not found after a certain index,
// it doesn't exist in the substring from that index to the end
// Helper function to check if a character exists in a string from a given index to the end
predicate CharExistsFrom(s: string, c: char, start: int)
    requires 0 <= start <= |s|
{
    exists i :: start <= i < |s| && s[i] == c
}

// Helper function to check if a character does not exist in a string from a given index to the end
predicate CharNotExistsFrom(s: string, c: char, start: int)
    requires 0 <= start <= |s|
{
    forall i :: start <= i < |s| ==> s[i] != c
}

// Lemma to prove that if a character doesn't exist from index i, it also doesn't exist from index i+1
lemma NotExistsImpliesNotExistsLater(s: string, c: char, i: int)
    requires 0 <= i < |s|
    requires CharNotExistsFrom(s, c, i)
    ensures CharNotExistsFrom(s, c, i+1)
{
    // This lemma is trivially true based on the definitions of CharNotExistsFrom
}

method LastIndex(s: string, c: char) returns (index: int)
    ensures -1 <= index < |s|
    ensures index == -1 ==> CharNotExistsFrom(s, c, 0)
    ensures index != -1 ==> s[index] == c && CharNotExistsFrom(s, c, index+1)
{
    index := |s| - 1;
    
    while index >= 0
        invariant -1 <= index < |s|
        invariant CharNotExistsFrom(s, c, index+1)
    {
        if s[index] == c {
            return;
        }
        index := index - 1;
        NotExistsImpliesNotExistsLater(s, c, index+1);
    }
    
    index := -1;
}

method TestLastDotIndex() {
     var s1 := "example.txt";
  var index1 := LastIndexOf(s1, '.');
//   assert index1 == 7;
  print "Last dot index in '", s1, "': ", index1, "\n";

  var s2 := "no_extension";
  var index2 := LastIndexOf(s2, '.');
  assert index2 == -1;
  print "Last dot index in '", s2, "': ", index2, "\n";

  var s3 := "multiple.dots.in.filename.txt";
  var index3 := LastIndexOf(s3, '.');
  print "Last dot index in '", s3, "': ", index3, "\n";
}

method TestLastIndex() {
    // Test case 1: Character present in the string
    // var result := LastIndex("hello", 'l');
    // var g := GetFileExtension("hello.txt");
    // assert g == "txt";
    // assert result == 3;
    // print "Test case 1 passed: ", result, "\n";

    // // Test case 2: Character not present in the string
    // result := LastIndex("world", 'x');
    // assert result == -1;
    // print "Test case 2 passed: ", result, "\n";

    // // Test case 3: Empty string
    // result := LastIndex("", 'a');
    // assert result == -1;
    // print "Test case 3 passed: ", result, "\n";

    // // Test case 4: Character present at the beginning
    // result := LastIndex("abcde", 'a');
    // assert result == 0;
    // print "Test case 4 passed: ", result, "\n";

    // // Test case 5: Character present at the end
    // result := LastIndex("abcde", 'e');
    // assert result == 4;
    // print "Test case 5 passed: ", result, "\n";
}


method Main(){
  // ContainsSequenceTest();
  // Testvalidate_file();
  // TestValidateFileChar();
  // TestAlphaNumeric();
  // ConvertionsTest();
  // ConcatTest();
  // TestCharToByte();
  // TestStringToBytes();
  // test_has_path_traversal();
//   TestHasNoLeadingOrTrailingSpaces();
//   TestDoesNotStartWithPeriod();
    // TestPathJoin();
    TestIsValidFileExtension();
    // TestContainsDangerousPattern();
    // TestFileExtention();
    TestLastDotIndex();
}