method ContainsSequence(list: seq<seq<char>>, sub: seq<char>) returns (result: bool)
  ensures result <==> (exists i :: 0 <= i < |list| && sub == list[i]) || sub in list
{
  result := false;
  for i := 0 to |list|
    invariant 0 <= i <= |list|
    invariant result <==> (exists k :: 0 <= k < i && sub == list[k])
  {
    if sub == list[i] {
      result := true;
      break;
    }
  }
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
}
// method findSubstr(str: seq<char>, substr: seq<char>) returns (result: bool)
//   requires |substr| > 0 && |substr| <= |str| && |str| > 0
//   ensures result <==> (exists i,j :: 0 <= i <= j < |str|  && (substr[i] == str[j]))
// {
//   result := false;
//   var i := 0;
//   while i < |s|
//     invariant 0 <= i <= |s|
//     invariant result <==> (exists k :: 0 <= k < i && (s[k] == c))
//   {
//     if s[i] == c {
//       assert c in s;
//       result := true;
//       break;
//     }
//     assert result <==> (exists k :: 0 <= k < i && (s[k] == c));
//     i := i + 1; 

//   }

// }

// method ContainsCTest(){
//   var out1:=ContainsC("pythonz", 'z');
//   // expect out1==true;
//   var c := 'z';
// //   assert c in "pythonz";
//   assert out1;

//   var out2:=ContainsC("xyz.", 'z');
// //   expect out2==true;
//   assert 'z' in "xyz.";
//   assert out2;

//   var out3:=ContainsC("  lang  .", 'z');
// //   expect out3==false;
//     assert 'z' !in "  lang  .";
//     assert !out3;

// }

// method Main(){
//   ContainsCTest();
// }
