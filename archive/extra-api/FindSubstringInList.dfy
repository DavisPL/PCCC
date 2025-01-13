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

function contains_sequence(list: seq<seq<char>>, sub: seq<char>): bool
  ensures contains_sequence(list, sub) <==> (exists i :: 0 <= i < |list| && sub == list[i])
{
  if |list| == 0 then
    false
  else if sub == list[0] then
    true
  else
    contains_sequence(list[1..], sub)
}

method ContainsSequenceTest(){
  var s1: seq<seq<char>> := [['H','e','l','l','o'],['W','o','r','l','d']];
  var s2: seq<char> := ['W','o','r','l','d'];
  var res1:=ContainsSequence(s1,s2);
  var r1 := contains_sequence(s1, s2);
  assert r1 == res1;
  // assert s2 in s1;
  assert res1;
  // expect res1==false;

  var s3: seq<seq<char>> := ["../../etc/passwd", "/usr/bin/"];
  var s4: seq<char> := "../../etc/passwd";
  var res2:=ContainsSequence(s3,s4);
  // expect res2==true;
  assert res2;

  var s6: seq<char> := "../local/bin";
  var res3:=ContainsSequence(s3,s6);
  assert !res3;
  // expect res3==false;

}

method Main(){
  ContainsSequenceTest();
}