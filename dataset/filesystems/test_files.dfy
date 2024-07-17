include "/Users/pari/pcc-llms/pccc/dataset/filesystems/files_sp_api.dfy"
method TestAlphaNumeric()
{
    var c1 := 'a';
    assert alpha_numeric(c1);
    var c2 := 'A';
    assert alpha_numeric(c2);
    var c3 := 'z';
    assert alpha_numeric(c3);
    var c4 := 'Z';
    assert alpha_numeric(c4);
    var c5 := '0';
    assert alpha_numeric(c5);
    var c6 := '9';
    assert alpha_numeric(c6);
    var c7 := ' ';
    assert !alpha_numeric(c7);
    var c8 := '.';
    assert !alpha_numeric(c8);
    var s1 := "hello";
    assert forall i :: 0 <= i < |s1| ==> alpha_numeric(s1[i]);
    var s2 := "hello1";
    assert forall i :: 0 <= i < |s2| ==> alpha_numeric(s2[i]);
    var s3 := "hello1.";
    assert !alpha_numeric(s3[6]);
}

method TestValidateFileChar()
{
    var c1 := 'a';
    assert validate_file_char(c1);
    var c2 := 'A';
    assert validate_file_char(c2);
    var c3 := 'z';
    assert validate_file_char(c3);
    var c4 := 'Z';
    assert validate_file_char(c4);
    var c5 := '0';
    assert validate_file_char(c5);
    var c6 := '9';
    assert validate_file_char(c6);
    var c7 := ' ';
    assert !validate_file_char(c7);
    var c8 := '.';
    assert validate_file_char(c8);
    // var c9 := '_';
    // assert validate_file_char(c9);
    var c10 := '-';
    assert validate_file_char(c10);
    // var c11 := '/';
    // assert validate_file_char(c11);
    var c12 := '!';
    assert !validate_file_char(c12);
    var c13 := '@';
    assert !validate_file_char(c13);
}

method TestValidateFileName()
{
    var c1 := 'a';
    assert validate_file_char(c1);
    var c2 := 'A';
    assert validate_file_char(c2);
    var c3 := 'z';
    assert validate_file_char(c3);
    var c4 := 'Z';
    assert validate_file_char(c4);
    var c5 := '0';
    assert validate_file_char(c5);
    var c6 := '9';
    assert validate_file_char(c6);
    var c7 := ' ';
    assert !validate_file_char(c7);
    var c8 := '.';
    assert validate_file_char(c8);
    var c9 := '-';
    assert validate_file_char(c9);
    var c10 := '!';
    assert !validate_file_char(c10);
    var c11 := '@';
    assert !validate_file_char(c11);
    var fileName2: seq<char> := "@.txt";
    var c := fileName2[0];
    assert c == '@';
    var isChar1 := validate_file_char(c);
    assert !isChar1;
    var fileName5: seq<char> := ".....file5";
}
 method TestIsValidFileName() 
   
{
  // Valid file names
  var s1 := ValidateFileName("file.txt");
  assert s1;
  var s2 := ValidateFileName("File1");
  assert s2;
  var s3 := ValidateFileName("longFileNameWithNumbers-2736.txt");
  assert s3;

    // Invalid file names
    // var s4 := ValidateFileName("file name");
    // assert s4;
    //   var s5 := ValidateFileName(".file");
    //   assert s5;
    //   var s6 := ValidateFileName("file.");
    //   assert s6;
    // var s7 := ValidateFileName("file name");
    // assert !s7;
    // var s9 := ValidateFileName("file_name");
    // assert s9;
    var s8 := ValidateFileName("file-name");
    assert s8;
}

method ContainsSequenceTest(){
  var s1: seq<seq<char>> := [['H','e','l','l','o'],['W','o','r','l','d']];
  var s2: seq<char> := ['W','o','r','l','d'];
  var res1:=ContainsSequence(s1,s2);
  // assert s2 in s1;
  assert res1;
  // expect res1==false;

  var s3: seq<seq<char>> := ["Hi", "Bye"];
  var s4: seq<char> := "bye";
  var res2:=ContainsSequence(s3,s4);
  // expect res2==true;
  assert !res2;

  // var s5: seq<seq<char>> := [[2,4,3,5,7],[1,0]];
  // var s6: seq<char> := [1,6];
  // var res3:=ContainsSequence(s5,s6);
  // expect res3==false;

}

method Main(){
  ContainsSequenceTest();
  TestValidateFileName();
  TestValidateFileChar();
  TestAlphaNumeric();
}

// lemma StringSliceLemma(s: seq<char>)
// requires 0 <= |s|
// ensures forall i:: 0 <= i < |s| ==> s[..(i+1)] == s[..i] + [s[i]]
// {
//     assert |s| == 0 || |s| > 0;
//     assert forall i:: 0 <= i < |s| ==> s[..(i+1)] == s[..i] + [s[i]];
// }

// lemma StringContainsLemma(s: seq<char>, c: char)
// ensures forall j:: 0 <= j < |s| ==> s[..(j+1)] == s[..j] + [s[j]]
// {
//     assert forall j:: 0 <= j < |s| ==> s[..(j+1)] == s[..j] + [s[j]];
// }

// function Contains(s: seq<char>, c:char): int
// {
//     if c !in s then -1 else ;
// }

// method StringContainsC(s: seq<char>, c: char) returns (idx: int)
// requires 0 < |s|
// ensures 0 <= idx <= |s| || idx == -1
// ensures forall j:: 0 <= j < |s| ==> s[..(j+1)] == s[..j] + [s[j]]
// ensures forall j :: 0 <= j < idx ==> s[j] != c
// {
//     var i := 0;
//     while i < |s|
//     invariant 0 <= i <= |s|
//     invariant forall j:: 0 <= j < i ==> s[j] != c
//     invariant forall j:: 0 <= j < |s| ==> s[..(j+1)] == s[..j] + [s[j]]
//     // invariant idx != -1 ==> s[idx] == c 
//     {
//         StringSliceLemma(s);
//         if s[i] == c {
//             idx := i;
//             return;
//         }
//         i := i + 1;
//     }
//     idx := -1;
// }
// method TestStringContainsC() {
//     // var s: seq<char> := "hello";
//     // var idx := StringContainsC(s, 'h');
//     // assert idx == 0;
//     // var idx2 := StringContainsC(s, 'o');
//     // assert idx2 == 4;
//     assert 'y' in "yfhfjturtyehgffd#448972673*^^%%$$dh.dhdh";
//     assert 'h' in "hello";
//     var s: seq<char> := "hello";
//     // var idx := StringContainsC(s, 'h');
// }
// method TestStringSlice() {
//     var s: seq<char> := "hello";
//     assert s[..(5)] == "hello";
//     assert s[..(4)] == "hell";
//     assert s[..(3)] == "hel";
//     assert s[..(2)] == "he";
//     assert s[..(1)] == "h";
//     assert s[..(0)] == "";
//     assert [s[4]] == "o";
//     assert s[..(5)] == s[..4] + [s[4]];
//     var sl := StringSlice(s, 4);
//     // assert s[..(4)] == sl;
//     assert sl == "hell";
    
// }






// method{:error "errorMessage", "successMessage"} TestIsValidFileName() {
//     var fileName1: seq<char> := "fuehehile1.txt";
//     var fileName2: seq<char> := "@.txt";
//     var fileName3: seq<char> := "imhdhdg.jpg";
//     var fileName4: seq<char> := "file4tete";
//     var fileName5: seq<char> := ".....file5";
//     var fileName6: seq<char> := "file6..";
//     var fileName7: seq<char> := "f2";
//     var isValid1 := validate_file_name(fileName1);
//     assert alpha_numeric(fileName1[0]);
//     assert alpha_numeric(fileName1[|fileName1| - 1]);
//     assert forall i :: 1 <= i < |fileName1| - 1  ==> validate_file_char(fileName1[i]);
//     assert !alpha_numeric(fileName5[0]) && alpha_numeric(fileName5[|fileName5| - 1]);
//     assert forall i :: 1 <= i < |fileName5| - 1  ==> validate_file_char(fileName5[i]);
//     assert isValid1; // This should hold as 'file1.txt' is a valid file name
//     var c := fileName2[0];
//     assert c == '@';
//     var isChar1 := validate_file_char(c);
//     assert !isChar1;
//     var c2 := fileName5[0];
//     assert c2 == '.';
//     var isChar2 := alpha_numeric(c2);
//     assert !isChar2;
//     // var isValid2 := ValidateFileName(fileName2);
//     // assert !isValid2; // This should hold as 'file2@.txt' is not a valid file name
//     // var isValid3 := ValidateFileName(fileName3);
//     // assert isValid3; // This should hold as 'img.jpg' is a valid file name
//     // var isValid4 := ValidateFileName(fileName4);
//     // assert  isValid4; // This should hold as '.file4' is not a valid file name 
//     // var isValid5 := ValidateFileName(fileName5);
//     // assert !isValid5; // This should hold as '.....file5' is not a valid file name
//     // var isValid6 := ValidateFileName(fileName6);
//     // assert !isValid6; // This should hold as 'file6.' is not a valid file name
//     // // This assertion should not be verified because the precondition is not satisfied
//     // // uncomment the following lines to see the result
//     // var isValid7 := ValidateFileName(fileName7);
//     // assert isValid7; // This should hold as 'f.txt' is not a valid file name
// }

// method ContainsSpecificValues(arr: array<int>) returns (result: bool)
//     requires arr != null
//     requires arr.Length > 0
//     ensures result <==> (exists i :: 0 <= i < arr.Length && arr[i] == 2) &&
//                         (exists i :: 0 <= i < arr.Length && arr[i] == 3) &&
//                         (exists i :: 0 <= i < arr.Length && arr[i] == 100)
//     ensures forall i :: 0 <= i < arr.Length ==> arr[i] == old(arr[i])
// {
//     var found2, found3, found100 := false, false, false;
//     var i := 0;
//     while i < arr.Length
//         invariant 0 <= i <= arr.Length
//         invariant found2 <==> (exists j :: 0 <= j < i && arr[j] == 2)
//         invariant found3 <==> (exists j :: 0 <= j < i && arr[j] == 3)
//         invariant found100 <==> (exists j :: 0 <= j < i && arr[j] == 100)
//     {
//         if arr[i] == 2 { found2 := true;
//             assert found2;
//             assert arr[i] == 2;
//             assert found2 <==> exists j :: (0 <= j < i ==> arr[j] == arr[i] == 2);
//         }
//         if arr[i] == 3 { found3 := true;
//             assert found3;
//             assert arr[i] == 3;
//             assert found3 <==> exists j :: (0 <= j < i ==> arr[j] == arr[i] == 3);
//         }
//         if arr[i] == 100 { found100 := true; 
        
//             assert found100;
//             assert arr[i] == 100;
//             assert found100 <==> exists j :: (0 <= j < i ==> arr[j] == arr[i] == 100);
//         }
//         //  assert found2 <==> exists j :: (0 <= j < i ==> arr[j] == arr[i] == 2);
//         i := i + 1;
//         // assert found2 <==> (exists j :: 0 <= j < i && arr[j] == 2);
//     }
    
//     result := found2 && found3 && found100;
// }

// method Main() {
//     var arr1 := new int[5] [1, 2, 3, 100, 5];
//     var result1 := ContainsSpecificValues(arr1);
//     print "Result 1: ", result1, "\n";  // Should print true
//     // assert result1;

//     var arr2 := new int[5] [1, 2, 3, 4, 5];
//     var result2 := ContainsSpecificValues(arr2);
//     print "Result 2: ", result2, "\n";  // Should print false
//     assert !result2;

// }

// method CompareLogicalExpressions()
// {
//     var arr: seq<int> :=  [1, 2, 3, 4, 5];
//     var i := 4;  // Consider the whole array
    
//     // Correct expression
//     var j := 1;
//     // assert j == 1 ==> arr[j] == 2;
//     // assert j != 1 ==> arr[j] != 2 || arr[j] == 2;
//     assert 2 in arr;
//     assert exists j :: 0 <= j <= i && arr[j] == 2;
//     // This is true because arr[1] == 2

//     // Incorrect expression
//     // assert exists j :: 0 <= j <= i ==> arr[j] == 2;
//     // This is also true, but for the wrong reason!
//     // It's true because the implication is true for j = 0 (1 != 2)

//     // To see why the second assertion is problematic, consider this:
//     var arr2 := new int[5] [1, 3, 4, 5, 6];  // No 2 in this array
//     // assert exists j :: 0 <= j <= i ==> arr2[j] == 2;
//     // This still verifies! But it shouldn't for our purposes.

//     // However, the correct expression fails for arr2:
//     // Uncomment the next line to see it fail
//     // assert exists j :: 0 <= j <= i && arr2[j] == 2;
// }