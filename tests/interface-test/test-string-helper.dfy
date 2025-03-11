include "../../std/utils/Utils.dfy"
    //This method should return true iff pre is a prefix of str. That is, str starts with pre
   // We spent 2h each on this assignment

predicate isPrefixPred(pre:string, str:string)
{
	(|pre| <= |str|) && 
	pre == str[..|pre|]
}

predicate isNotPrefixPred(pre:string, str:string)
{
	(|pre| > |str|) || 
	pre != str[..|pre|]
}

lemma PrefixNegationLemma(pre:string, str:string)
	ensures  isPrefixPred(pre,str) <==> !isNotPrefixPred(pre,str)
	ensures !isPrefixPred(pre,str) <==>  isNotPrefixPred(pre,str)
{}

method isPrefix(pre: string, str: string) returns (res:bool)
	ensures !res <==> isNotPrefixPred(pre,str)
	ensures  res <==> isPrefixPred(pre,str)
{
	if |pre| > |str|
    	{return false;}

  	var i := 0;
  	while i < |pre|
    	decreases |pre| - i
    	invariant 0 <= i <= |pre|
    	invariant forall j :: 0 <= j < i ==> pre[j] == str[j]
  	{
    	if pre[i] != str[i]
    	{
       		return false;
    	} 
    	i := i + 1;
  	}
 	return true;
}
predicate isSubstringPred(sub:string, str:string)
{
	(exists i :: 0 <= i <= |str| &&  isPrefixPred(sub, str[i..]))
}

predicate isNotSubstringPred(sub:string, str:string)
{
	(forall i :: 0 <= i <= |str| ==> isNotPrefixPred(sub,str[i..]))
}

lemma SubstringNegationLemma(sub:string, str:string)
	ensures  isSubstringPred(sub,str) <==> !isNotSubstringPred(sub,str)
	ensures !isSubstringPred(sub,str) <==>  isNotSubstringPred(sub,str)
{}

method isSubstring(sub: string, str: string) returns (res:bool)
	ensures  res <==> isSubstringPred(sub, str)
	//ensures !res <==> isNotSubstringPred(sub, str) // This postcondition follows from the above lemma.
{
	if |sub| > |str| {
        return false;
    }

    var i := |str| - |sub|;
    while i >= 0 
    decreases i
    invariant i >= -1
    invariant forall j :: i <  j <= |str|-|sub| ==> !(isPrefixPred(sub, str[j..]))
    {
        var isPref := isPrefix(sub, str[i..]);
        if isPref
        {
            return true;
        }
        i := i-1;
    }
    return false;
}

predicate haveCommonKSubstringPred(k:nat, str1:string, str2:string)
{
	exists i1, j1 :: 0 <= i1 <= |str1|- k && j1 == i1 + k && isSubstringPred(str1[i1..j1],str2)
}

predicate haveNotCommonKSubstringPred(k:nat, str1:string, str2:string)
{
	forall i1, j1 :: 0 <= i1 <= |str1|- k && j1 == i1 + k ==>  isNotSubstringPred(str1[i1..j1],str2)
}

lemma commonKSubstringLemma(k:nat, str1:string, str2:string)
	ensures  haveCommonKSubstringPred(k,str1,str2) <==> !haveNotCommonKSubstringPred(k,str1,str2)
	ensures !haveCommonKSubstringPred(k,str1,str2) <==>  haveNotCommonKSubstringPred(k,str1,str2)
{}

method haveCommonKSubstring(k: nat, str1: string, str2: string) returns (found: bool)
	ensures found  <==>  haveCommonKSubstringPred(k,str1,str2)
	//ensures !found <==> haveNotCommonKSubstringPred(k,str1,str2) // This postcondition follows from the above lemma.
{
	 if( |str1| < k || |str2| < k){
        return false;
    }
    var i := |str1| - k;
    while i >= 0
      decreases i
      invariant i >= -1 
      invariant forall j,t :: i < j <= |str1| - k && t==j+k ==> !isSubstringPred(str1[j..t], str2)
    {
				var t := i+k;
        var isSub := isSubstring(str1[i..t], str2);
        if isSub 
        {
            return true;
        }
        i := i-1;
    }
    return false;
}

method maxCommonSubstringLength(str1: string, str2: string) returns (len:nat)
	requires (|str1| <= |str2|)
	ensures (forall k :: len < k <= |str1| ==> !haveCommonKSubstringPred(k,str1,str2))
	ensures haveCommonKSubstringPred(len,str1,str2)
{
	var i := |str1|;

  	while i > 0
  	decreases i
  	invariant i >= 0
  	invariant forall j :: i < j <= |str1| ==> !haveCommonKSubstringPred(j, str1, str2)
  	{
    	var ans := haveCommonKSubstring(i, str1, str2);
    	if ans {
       		return i;
    	}
    	i := i -1;
  	}
  	assert i == 0;
	assert isPrefixPred(str1[0..0],str2[0..]);
  	return 0;
}

  method HaveCommonKSubstring(k:nat, str1:string, str2:string) returns(found:bool)
        requires 0 < k <= |str1| &&  0 < k <= |str2| //This method requires that k > 0 and k is less than or equal to in length to str1 and str2
    {
        //Initialising the index variable
        var i := 0;

        //This variable is used to define the end condition of the while loop
        var n := |str1|-k;

        //Here, we want to re-use the "isSubstring" method above, so with each iteration of the search, we are passing a substring of str1 with length k and searching for this substring in str2. If the k-length substring is not found, we "slide" the length-k substring "window" along and search again
            //example:
            //str1 = operation, str2 = rational, k = 5
            //Iteration 1: isSubstring(opera, rational), returns false, slide the substring & iterate again
            //Iteration 2: isSubstring(perat, rational), returns false, slide the substring & iterate again
            //Iteration 3: isSubstring(erati, rational), returns false, slide the substring & iterate again
            //Iteration 4: isSubstring(ratio, rational), returns true, stop iterating

        while(i < n)
            decreases n - i //Specifying that the loop will terminate
        {
            //Debug print to show what is being passed to isSubstring with each iteration
            print "\n", str1[i..i+k], ", ", str2, "\n";

            var result := isSubstring(str1[i..i+k], str2);

            //Return once the length-k substring is found, no point in iterating any further
            if(result == true){
                return true;
            }
            //Else loop until the length-k substring is found, or we have reached the end condition
            else{
                i:=i+1;
            }
        }
        return false;
    }



method Main() {
    var dir := "/usr/bin/python";
    var prefix := "/usr";
    var res := Utils.IsSubstring(prefix, dir);
    expect res, "/usr in /usr/bin/python";
    // assert res;
    var dir2 := "/usr/bin/python";
    var prefix2 := "/home";
    var res2 := Utils.IsSubstring(prefix, dir2);
    expect res2, "/home in /usr/bin/python";
    // assert dir2[..1] == "/";
    assert dir2[..5] == "/usr/"; //Comment me! Without this line the asssertion in line 27 will fail
    print(res2);
    var dir3 := "/usr/bin/python";
    var prefix3 := "/bin";
    var res3 := Utils.HaveCommonKSubstring(4, dir3, prefix3);
    expect res3,"res3";
    // assert res3;

}