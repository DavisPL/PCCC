predicate SequenceInList(list: seq<seq<char>>, sub: seq<char>)
{
  exists i :: 0 <= i < |list| && sub == list[i]
}

// Helper function to check if a sequence is in the list up to a certain index
function SequenceInListUpTo(list: seq<seq<char>>, sub: seq<char>, upTo: int): bool
  requires 0 <= upTo <= |list|
{
  exists k :: 0 <= k < upTo && sub == list[k]
}

// The main predicate that combines both conditions
predicate ContainsSequencePredicate(list: seq<seq<char>>, sub: seq<char>)
{
  SequenceInList(list, sub) || sub in list
}

// Lemma to prove the relationship between SequenceInList and SequenceInListUpTo
lemma SequenceInListEquivalence(list: seq<seq<char>>, sub: seq<char>)
  ensures SequenceInList(list, sub) <==> SequenceInListUpTo(list, sub, |list|)
{
  if SequenceInList(list, sub) {
    var i :| 0 <= i < |list| && sub == list[i];
    assert SequenceInListUpTo(list, sub, |list|);
  }
  if SequenceInListUpTo(list, sub, |list|) {
    var k :| 0 <= k < |list| && sub == list[k];
    assert SequenceInList(list, sub);
  }
}

method ContainsSequence(list: seq<seq<char>>, sub: seq<char>) returns (result: bool)
  ensures result <==> ContainsSequencePredicate(list, sub)
{
  result := false;
  for i := 0 to |list|
    invariant 0 <= i <= |list|
    invariant result <==> SequenceInListUpTo(list, sub, i)
  {
    if sub == list[i] {
      result := true;
      break;
    }
  }

  SequenceInListEquivalence(list, sub);
}

method TestContainsSequence()
{
  // Test case 1: Empty list
  var emptyList: seq<seq<char>> := [];
  var result := ContainsSequence(emptyList, "test");
  assert !result;
  print "Test case 1 (Empty list): ", result, "\n";

  // Test case 2: Sequence present in the list
  var list1: seq<seq<char>> := [['a', 'b', 'c'], ['d', 'e', 'f'], ['g', 'h', 'i']];
  result := ContainsSequence(list1, ['d', 'e', 'f']);
  assert result;
  print "Test case 2 (Sequence present): ", result, "\n";

  // Test case 3: Sequence not present in the list
  result := ContainsSequence(list1, ['x', 'y', 'z']);
  assert !result;
  print "Test case 3 (Sequence not present): ", result, "\n";

  // Test case 4: Empty sequence
  result := ContainsSequence(list1, []);
  assert !result; // Empty sequence is not considered to be in the list
  print "Test case 4 (Empty sequence): ", result, "\n";

  // Test case 5: Sequence present as a substring
  var list2: seq<seq<char>> := [['h', 'e', 'l', 'l', 'o'], ['w', 'o', 'r', 'l', 'd']];
  result := ContainsSequence(list2, ['e', 'l', 'l']);
  assert !result;
  print "Test case 5 (Sequence as substring): ", result, "\n";

  // Test case 6: Single-element list
  var singleList: seq<seq<char>> := [['a', 'b', 'c'], ['h', 'e', 'l', 'l', 'o'], ['w', 'o', 'r', 'l', 'd']];
  result := ContainsSequence(singleList, "abc");
  assert result;
  print "Test case 6 (Single-element list): ", result, "\n";

  print "All test cases completed.\n";
}

method Main()
{
  TestContainsSequence();
}