method CountSubstringsWithSumEqualToLength(s: string) returns (count: int)
    ensures count >= 0
    ensures count == CountSubstrings(s)
{
    count := 0;
    var n := |s|;
    for start := 0 to n
        invariant 0 <= start <= n
        invariant count >= 0
        invariant count == CountSubstrings(s[0..start])
    {
        var sum := 0;
        for end := start to n
            invariant start <= end <= n
            invariant sum == Sum(s[start..end])
            invariant count == Old(count) + (sum == end - start ? 1 : 0)
        {
            sum := sum + s[end] - '0';
            if sum == end - start {
                count := count + 1;
            }
        }
    }
}

function Sum(substring: string) : int
{
    var sum := 0;
    for i := 0 to |substring|
        invariant 0 <= i <= |substring|
        invariant sum == SumDigits(substring[0..i])
    {
        sum := sum + substring[i] - '0';
    }
    return sum;
}

function SumDigits(s: string) : int
{
    var sum := 0;
    for i := 0 to |s|
        invariant 0 <= i <= |s|
        invariant sum == SumDigitsHelper(s[0..i])
    {
        sum := sum + s[i] - '0';
    }
    return sum;
}

function SumDigitsHelper(s: string) : int
{
    var sum := 0;
    for i := 0 to |s|
        invariant 0 <= i <= |s|
        invariant sum == Sum(s[0..i])
    {
        sum := sum + s[i] - '0';
    }
    return sum;
}

function CountSubstrings(s: string) : int
{
    var count := 0;
    var n := |s|;
    for start := 0 to n
        invariant 0 <= start <= n
        invariant count >= 0
        invariant count == CountSubstringsHelper(s[0..start])
    {
        for end := start to n
            invariant start <= end <= n
            invariant count == Old(count) + (Sum(s[start..end]) == end - start ? 1 : 0)
        {}
    }
    return count;
}

function CountSubstringsHelper(s: string) : int
{
    var count := 0;
    var n := |s|;
    for start := 0 to n
        invariant 0 <= start <= n
        invariant count >= 0
        invariant count == CountSubstrings(s[0..start])
    {
        for end := start to n
            invariant start <= end <= n
            invariant count == Old(count) + (Sum(s[start..end]) == end - start ? 1 : 0)
        {}
    }
    return count;
}