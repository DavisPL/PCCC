// // // Function to check if a string contains a substring
// // function ContainsSub(s: string, sub: string): bool
// // {
// //   exists i :: 0 <= i <= |s| - |sub| && s[i..i+|sub|] == sub
// // }
// // // Lemma to prove that if we find a matching substring at an index, the string contains the substring
// // lemma SubstringAtIndexImpliesContains(s: string, sub: string, index: int)
// //   requires 0 <= index <= |s| - |sub|
// //   requires s[index..index+|sub|] == sub
// //   ensures ContainsSub(s, sub)
// // {
// //   // Prove that the index satisfies the existential quantifier in ContainsSub
// //   assert exists i :: 0 <= i <= |s| - |sub| && s[i..i+|sub|] == sub by {
// //     assert 0 <= index <= |s| - |sub| && s[index..index+|sub|] == sub;
// //   }
// // }

// // // Method to find the index of a substring in a string
// // method FindSubstring(s: string, sub: string) returns (result: int)
// //   ensures result == -1 ==> !ContainsSub(s, sub)
// //   ensures 0 <= result <= |s| - |sub| ==> s[result..result+|sub|] == sub
// //   ensures 0 <= result <= |s| - |sub| ==> ContainsSub(s, sub)
// // {
// //   if |sub| == 0 {
// //     return 0;  // Empty substring is always found at the beginning
// //   }
// //   if |sub| > |s| {
// //     return -1;  // Substring longer than string, can't be found
// //   }
  
// //   var i := 0;
// //   while i <= |s| - |sub|
// //     invariant 0 <= i <= |s| - |sub| + 1
// //     invariant forall k :: 0 <= k < i && k <= |s| - |sub| ==> s[k..k+|sub|] != sub
// //   {
// //     if s[i..i+|sub|] == sub {
// //       SubstringAtIndexImpliesContains(s, sub, i);
// //       return i;
// //     }
// //     i := i + 1;
// //   }
// //   return -1;  // Substring not found
// // }
// // // // Method to find the index of a substring in a string
// // // method FindSubstring(s: string, sub: string) returns (result: int)
// // //   ensures result == -1 ==> !Contains(s, sub)
// // //   ensures 0 <= result < |s| ==> s[result..result+|sub|] == sub
// // // {
// // //   result := -1;
// // //   var i := 0;
// // //   while i <= |s| - |sub|
// // //     invariant 0 <= i <= |s| - |sub| + 1
// // //     invariant result == -1 ==> forall k :: 0 <= k < i ==> s[k..k+|sub|] != sub
// // //     invariant 0 <= result < i ==> s[result..result+|sub|] == sub
// // //   {
// // //     if s[i..i+|sub|] == sub {
// // //       SubstringAtIndexImpliesContains(s, sub, i);
// // //       result := i;
// // //       return;
// // //     }
// // //     i := i + 1;
// // //   }
// // // }

// // // method Main()
// // // {
// // //   var s := "Hello, World!";
// // //   var sub1 := "World";
// // //   var sub2 := "OpenAI";

// // //   var index1 := FindSubstring(s, sub1);
// // //   if index1 != -1 {
// // //     assert Contains(s, sub1);
// // //     print "Found '", sub1, "' at index ", index1, "\n";
// // //   } else {
// // //     assert !Contains(s, sub1);
// // //     print "'", sub1, "' not found in the string\n";
// // //   }

// // //   var index2 := FindSubstring(s, sub2);
// // //   if index2 != -1 {
// // //     assert Contains(s, sub2);
// // //     print "Found '", sub2, "' at index ", index2, "\n";
// // //   } else {
// // //     assert !Contains(s, sub2);
// // //     print "'", sub2, "' not found in the string\n";
// // //   }
// // // }

// function ContainsSub(s: string, sub: string): bool
// {
//   exists i :: 0 <= i <= |s| - |sub| && s[i..i+|sub|] == sub
// }

// lemma SubstringAtIndexImpliesContains(s: string, sub: string, index: int)
//   requires 0 <= index <= |s| - |sub|
//   requires s[index..index+|sub|] == sub
//   ensures ContainsSub(s, sub)
// {
//   assert exists i :: 0 <= i <= |s| - |sub| && s[i..i+|sub|] == sub by {
//     assert 0 <= index <= |s| - |sub| && s[index..index+|sub|] == sub;
//   }
// }

// predicate NoMatchUpTo(s: string, sub: string, end: int)
//   requires 0 <= end <= |s|
//   requires 0 < |sub| <= |s|
// {
//   forall k :: 0 <= k <= end - |sub| ==> s[k..k+|sub|] != sub
// }

// lemma NoMatchUpToExtend(s: string, sub: string, end: int)
//   requires 0 <= end < |s|
//   requires 0 < |sub| <= |s|
//   requires NoMatchUpTo(s, sub, end)
//   requires s[end..end+|sub|] != sub
//   ensures NoMatchUpTo(s, sub, end + 1)
// {
//   forall k | 0 <= k <= (end + 1) - |sub|
//     ensures s[k..k+|sub|] != sub
//   {
//     if k < end - |sub| + 1 {
//       assert s[k..k+|sub|] != sub by {
//         assert NoMatchUpTo(s, sub, end);
//       }
//     } else {
//       assert k == end - |sub| + 1;
//       assert s[k..k+|sub|] == s[end..end+|sub|];
//     }
//   }
// }

// method FindSubstring(s: string, sub: string) returns (result: int)
//   ensures result == -1 ==> !ContainsSub(s, sub)
//   ensures 0 <= result <= |s| - |sub| ==> s[result..result+|sub|] == sub
//   ensures 0 <= result <= |s| - |sub| ==> ContainsSub(s, sub)
// {
//   if |sub| == 0 {
//     return 0;  // Empty substring is always found at the beginning
//   }
//   if |sub| > |s| {
//     return -1;  // Substring longer than string, can't be found
//   }
  
//   var i := 0;
//   while i <= |s| - |sub|
//     invariant 0 <= i <= |s| - |sub| + 1
//     invariant NoMatchUpTo(s, sub, i)
//   {
//     if s[i..i+|sub|] == sub {
//       SubstringAtIndexImpliesContains(s, sub, i);
//       return i;
//     }
//     assert s[i..i+|sub|] != sub;
//     NoMatchUpToExtend(s, sub, i);
//     i := i + 1;
//   }
//   return -1;  // Substring not found
// }

// method Main()
// {
//   var s := "Hello, World!";
//   var sub1 := "World";
//   var sub2 := "OpenAI";
//   var sub3 := "This is a very long substring that is longer than the main string";
//   var sub4 := "";  // Empty substring

//   var index1 := FindSubstring(s, sub1);
//   if index1 != -1 {
//     assert ContainsSub(s, sub1);
//     print "Found '", sub1, "' at index ", index1, "\n";
//   } else {
//     assert !ContainsSub(s, sub1);
//     print "'", sub1, "' not found in the string\n";
//   }

//   var index2 := FindSubstring(s, sub2);
//   if index2 != -1 {
//     assert ContainsSub(s, sub2);
//     print "Found '", sub2, "' at index ", index2, "\n";
//   } else {
//     assert !ContainsSub(s, sub2);
//     print "'", sub2, "' not found in the string\n";
//   }

//   var index3 := FindSubstring(s, sub3);
//   if index3 != -1 {
//     assert ContainsSub(s, sub3);
//     print "Found '", sub3, "' at index ", index3, "\n";
//   } else {
//     assert !ContainsSub(s, sub3);
//     print "'", sub3, "' not found in the string\n";
//   }

//   var index4 := FindSubstring(s, sub4);
//   if index4 != -1 {
//     assert ContainsSub(s, sub4);
//     print "Found empty substring at index ", index4, "\n";
//   } else {
//     assert !ContainsSub(s, sub4);
//     print "Empty substring not found (this should not happen)\n";
//   }
// }