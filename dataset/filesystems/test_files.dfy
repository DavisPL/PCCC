include "/Users/pari/pcc-llms/dataset/filesystems/files-helper.dfy"
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
  var s1 := "file.txt";
  var v1 := ValidateFileName("file.txt");
  if v1 {
    assert alpha_numeric(s1[0]);
    assert alpha_numeric(s1[|s1| - 1]);
    assert forall i :: 1 <= i < |s1| - 1  ==> validate_file_char(s1[i]);
  }
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
  // var s3: seq<seq<char>> := invalidFileTypes;
  var s4: seq<char> := "CON";

  var res3:=ContainsSequence(invalidFileTypes,s4);

  assert res3;
  var s3: seq<seq<char>> := ["Hi", "Bye"];
  var s5: seq<char> := "bye";
  var res2:=ContainsSequence(s3,s5);
  // expect res2==true;
  assert !res2;

  // var s5: seq<seq<char>> := [[2,4,3,5,7],[1,0]];
  // var s6: seq<char> := [1,6];
  // var res3:=ContainsSequence(s5,s6);
  // expect res3==false;

}

method ConvertionsTest(){
  var r := ComputeNumberToString(01234567890);
  assert r == number_to_string(01234567890);
  var charA := 'A';
  assert 65 == char_to_byte(charA);
  print "r " ,r ,"\n";
  print "Ascii of c is: ", char_to_byte(charA), "\n";
  var testString := "abcA";
  print "string is ", testString, "\n";
  var bytes := StringToBytes(testString);
  print "bytes ", bytes, "\n ";
  assert bytes[0] == 'a' as int; // Test each byte individually
  assert bytes[1] == 'b' as int;
  assert bytes[2] == 'c' as int;
  assert bytes[3] == 'A' as int;
  // If the testString is longer than 3 characters, this will fail
  assert |bytes| == 4; // Assert the length is as expected
  assert bytes == [97, 98, 99, 65];
}

method Main(){
  ContainsSequenceTest();
  TestValidateFileName();
  TestValidateFileChar();
  TestAlphaNumeric();
  ConvertionsTest();
}