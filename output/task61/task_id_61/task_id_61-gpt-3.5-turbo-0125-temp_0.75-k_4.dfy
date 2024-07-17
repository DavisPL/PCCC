method CountSubstringsWithSumEqualsLength(s: string) returns (count: int)
    requires s != null
    ensures count >= 0
    ensures count == SumSubstringsWithSumEqualsLength(s)
{
    count := 0;
    var i := 0;
    while i < |s|
        invariant 0 <= i <= |s|
        invariant count >= 0
        invariant count == SumSubstringsWithSumEqualsLength(s[0..i])
    {
        var sum := 0;
        var j := i;
        while j < |s|
            invariant i <= j <= |s|
            invariant sum == SumDigits(s[i..j])
            invariant count == SumSubstringsWithSumEqualsLength(s[0..i])
        {
            sum := sum + s[j] - '0';
            if sum == j - i + 1 {
                count := count + 1;
            }
            j := j + 1;
        }
        i := i + 1;
    }
}

function SumSubstringsWithSumEqualsLength(s: string) : int
{
    var count := 0;
    var i := 0;
    while i < |s|
        invariant 0 <= i <= |s|
        invariant count == SumSubstringsWithSumEqualsLength(s[0..i])
    {
        var sum := 0;
        var j := i;
        while j < |s|
            invariant i <= j <= |s|
            invariant sum == SumDigits(s[i..j])
            invariant count == SumSubstringsWithSumEqualsLength(s[0..i])
        {
            sum := sum + s[j] - '0';
            if sum == j - i + 1 {
                count := count + 1;
            }
            j := j + 1;
        }
        i := i + 1;
    }
    return count;
}

function SumDigits(sub: string) : int
{
    var sum := 0;
    for i := 0 to |sub|
        invariant 0 <= i <= |sub|
        invariant sum == SumDigits(sub[0..i])
    {
        sum := sum + sub[i] - '0';
    }
    return sum;
}