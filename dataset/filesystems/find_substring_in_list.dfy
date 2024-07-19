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

  var s3: seq<seq<char>> := ["../Hi", "/usr/bin/"];
  var s4: seq<char> := "../Hi";
  var res2:=ContainsSequence(s3,s4);
  // expect res2==true;
  assert res2;

  // var s5: seq<seq<char>> := [[2,4,3,5,7],[1,0]];
  // var s6: seq<char> := [1,6];
  // var res3:=ContainsSequence(s5,s6);
  // expect res3==false;

}

method Main(){
  ContainsSequenceTest();
}