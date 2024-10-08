lemma StringMatchAtImpliesEqualityForEachChar(s1: string, s2: string, start: int, i: int)
    requires StringMatchAt(s1, s2, start)
    requires 0 <= i < |s2|
    ensures s1[start + i] == s2[i]
{
    // The body can be empty; Dafny should be able to prove this automatically
}



// Helper function to check if two strings match at a specific index
predicate StringMatchAt(s1: string, s2: string, start: int)
{
    start >= 0 &&
    start + |s2| <= |s1| &&
    forall i :: 0 <= i < |s2| ==> 
        0 <= start + i < |s1| && // Explicit bounds check
        s1[start + i] == s2[i]
}

// Lemma to prove that if StringMatchAt is true, then the substring exists
lemma StringMatchImpliesSubstring(s: string, sub: string, i: int)
    requires 0 <= i <= |s| - |sub|
    requires StringMatchAt(s, sub, i)
    ensures s[i..i+|sub|] == sub
{
    if |sub| == 0 {
        // Base case: empty substring always matches
    } else {
        // Inductive case
        assert s[i] == sub[0];  // First character matches
        StringMatchAtImpliesEqualityForEachChar(s, sub, i, 0);
        
        // Recursive call for the rest of the string
        StringMatchImpliesSubstring(s[i+1..], sub[1..], 0);
    }
}

// lemma SubstringImpliesStringMatch(s: string, sub: string, i: int)
//     requires 0 <= i <= |s| - |sub|
//     requires s[i..i+|sub|] == sub
//     ensures StringMatchAt(s, sub, i)
// {
//     forall j | 0 <= j < |sub|
//     {
//         assert s[i+j] == sub[j];
//     }
// }



function FindSubstringIndex(sub: string, s: string): ( bool, int)
    ensures FindSubstringIndex(sub,s).0 ==> 0 <= FindSubstringIndex(sub,s).1 <= |s| - |sub| && StringMatchAt(s, sub, FindSubstringIndex(sub,s).1)
    ensures !FindSubstringIndex(sub,s).0 ==> FindSubstringIndex(sub,s).1 == -1
{
    if |sub| > |s| then
        (false, -1)
    else
        FindSubstringIndexHelper(sub, s, 0)
}

// Helper function for FindSubstringIndex
function FindSubstringIndexHelper(sub: string, s: string, start: int): ( bool, int)
     requires 0 <= start <= |s|
    decreases |s| - start
    ensures var (found, index) := FindSubstringIndexHelper(sub, s, start);
            found <==> start <= index <= |s| - |sub| && StringMatchAt(s, sub, index)
    ensures var (found, index) := FindSubstringIndexHelper(sub, s, start);
            !found <==> index == -1
{
    if start > |s| - |sub| then
        (false, -1)
    else if StringMatchAt(s, sub, start) then
        (true, start)
    else
        FindSubstringIndexHelper(sub, s, start + 1)
}

// Lemma to prove properties of FindSubstringIndexHelper
lemma FindSubstringIndexHelperProperties(sub: string, s: string, start: int)
    requires 0 <= start <= |s|
    ensures var (found, index) := FindSubstringIndexHelper(sub, s, start);
            found <==> 
                start <= index <= |s| - |sub| && 
                StringMatchAt(s, sub, index) &&
                (forall i :: start <= i < index ==> !StringMatchAt(s, sub, i))
    ensures var (found, index) := FindSubstringIndexHelper(sub, s, start);
            !found <==>
                index == -1 &&
                (forall i :: start <= i <= |s| - |sub| ==> !StringMatchAt(s, sub, i))
    decreases |s| - start
{
    if start > |s| - |sub| {
        // Base case: no match possible
        assert forall i :: start <= i <= |s| - |sub| ==> !StringMatchAt(s, sub, i);
    } else if StringMatchAt(s, sub, start) {
        // Match found at start
        assert forall i :: start <= i < start ==> !StringMatchAt(s, sub, i);
    } else {
        // Recursive case
        FindSubstringIndexHelperProperties(sub, s, start + 1);
        var (found, index) := FindSubstringIndexHelper(sub, s, start + 1);
        if found {
            assert start + 1 <= index <= |s| - |sub|;
            assert StringMatchAt(s, sub, index);
            assert forall i :: start + 1 <= i < index ==> !StringMatchAt(s, sub, i);
            assert !StringMatchAt(s, sub, start);
        } else {
            assert index == -1;
            assert forall i :: start + 1 <= i <= |s| - |sub| ==> !StringMatchAt(s, sub, i);
            assert !StringMatchAt(s, sub, start);
        }
    }
}

// Main IsSubstring predicate
predicate IsSubstring(sub: string, s: string)
{
    |sub| <= |s| && exists i :: 0 <= i <= |s| - |sub| && StringMatchAt(s, sub, i)
}




lemma WorldIsSubstringOfHelloWorld()
    ensures IsSubstring("world", "Hello, world!")
{
    var s := "Hello, world!";
    var sub := "world";
    var i := 7; // Index where "world" starts in "Hello, world!"
    
    assert 0 <= i <= |s| - |sub|;
    assert StringMatchAt(s, sub, i) by {
        assert forall j :: 0 <= j < |sub| ==>
            0 <= i + j < |s| && s[i + j] == sub[j];
    }
     assert IsSubstring("world", "Hello, world!");
}


// method TestIsSubstring()
// {

//     // Test FindSubstringIndex
//     var testCases := [
//         ("world", "Hello, world!", true, 7),
//         ("Hello", "Hello, world!", true, 0),
//         ("", "Hello, world!", true, 0),
//         ("", "", true, 0),
//         ("OpenAI", "Hello, world!", false, -1),
//         ("hello", "Hello, world!", false, -1)  // Case sensitive
//     ];

//     var allTestsPassed := true;

//     for i := 0 to |testCases|
//     invariant 0 <= i <= |testCases|
//     {
//         var (sub, s, expectedFound, expectedIndex) := testCases[i];
//         print "Testing: '", sub, "' in '", s, "'\n";

//         var (found, index) := FindSubstringIndex(sub, s);
//         print "Result: found=", found, ", index=", index, "\n";

//         // Call the lemma to ensure properties hold
//         FindSubstringIndexHelperProperties(sub, s, 0);

//         // Assertions to verify the correctness of FindSubstringIndex
//         assert found == expectedFound;
//         if found {
//             assert 0 <= index <= |s| - |sub|;
//             assert StringMatchAt(s, sub, index);
//             StringMatchImpliesSubstring(s, sub, index);
//             assert s[index..index+|sub|] == sub;
//             assert index == expectedIndex;
//             assert forall i :: 0 <= i < index ==> !StringMatchAt(s, sub, i);
//         } else {
//             assert index == -1;
//             assert forall i :: 0 <= i <= |s| - |sub| ==> !StringMatchAt(s, sub, i);
//         }

//         assert IsSubstring(sub, s) <==> found by {
//             if found {
//                 assert exists i :: 0 <= i <= |s| - |sub| && StringMatchAt(s, sub, i);
//             } else {
//                 assert forall i :: 0 <= i <= |s| - |sub| ==> !StringMatchAt(s, sub, i);
//             }
//         }

//        // Additional assertions to verify IsSubstring
//         assert IsSubstring(sub, s) <==> found by {
//             if found {
//                 assert exists i :: 0 <= i <= |s| - |sub| && StringMatchAt(s, sub, i);
//             } else {
//                 assert forall i :: 0 <= i <= |s| - |sub| ==> !StringMatchAt(s, sub, i);
//             }
//         }

//         // Verify that the result matches the expected outcome
//         if found != expectedFound || (found && index != expectedIndex) {
//             print "Test failed: expected (", expectedFound, ", ", expectedIndex, "), but got (", found, ", ", index, ")\n";
//             allTestsPassed := false;
//         }


//         // Additional debug information
//         if found {
//             print "Substring at index ", index, ": '", s[index..index+|sub|], "'\n";
//         }

//         print "\n";
//     }

//     if allTestsPassed {
//         print "All tests passed successfully!\n";
//     } else {
//         print "Some tests failed. Please check the output above.\n";
//     }
// }

method TestIsSubstring()
{
    var testCases := [
        ("world", "Hello, world!", true, 7),
        ("Hello", "Hello, world!", true, 0),
        ("", "Hello, world!", true, 0),
        ("", "", true, 0),
        ("OpenAI", "Hello, world!", false, -1),
        ("hello", "Hello, world!", false, -1)  // Case sensitive
    ];

    var allTestsPassed := true;

    for i := 0 to |testCases|
        invariant 0 <= i <= |testCases|
    {
        var (sub, s, expectedFound, expectedIndex) := testCases[i];
        print "Testing: '", sub, "' in '", s, "'\n";

        var (found, index) := FindSubstringIndex(sub, s);
        print "Result: found=", found, ", index=", index, "\n";

        // Call the lemma to ensure properties hold
        FindSubstringIndexHelperProperties(sub, s, 0);

        // Verify the correctness of FindSubstringIndex
        if found {
            assert 0 <= index <= |s| - |sub|;
            assert StringMatchAt(s, sub, index);
            StringMatchImpliesSubstring(s, sub, index);
            assert s[index..index+|sub|] == sub;
        } else {
            assert index == -1;
        }

        // Verify IsSubstring consistency
        assert IsSubstring(sub, s) <==> found by {
            if found {
                assert exists i :: 0 <= i <= |s| - |sub| && StringMatchAt(s, sub, i);
            } else {
                assert forall i :: 0 <= i <= |s| - |sub| ==> !StringMatchAt(s, sub, i);
            }
        }

        // Check if the result matches the expected outcome
        if found != expectedFound || (found && index != expectedIndex) {
            print "Test failed: expected (", expectedFound, ", ", expectedIndex, "), but got (", found, ", ", index, ")\n";
            allTestsPassed := false;
        } else {
            // Additional verification for positive cases
            if found {
                assert StringMatchAt(s, sub, index);
                assert s[index..index+|sub|] == sub;
            }
        }

        // Additional debug information
        if found {
            print "Substring at index ", index, ": '", s[index..index+|sub|], "'\n";
        }

        print "\n";
    }

    if allTestsPassed {
        print "All tests passed successfully!\n";
    } else {
        print "Some tests failed. Please check the output above.\n";
    }
}

// method Main()
// {
//     TestIsSubstring();
// }