method CountSubstringsWithSumEqualLength(s: string) returns (count: int)
    ensures count >= 0
    ensures count == CountValidSubstrings(s)
{
    count := 0;
    var n := |s|;
    for i := 0 to n
        invariant 0 <= i <= n
        invariant count == CountValidSubstrings(s[..i])
    {
        var sum := 0;
        for j := i to n
            invariant i <= j <= n
            invariant sum == SumDigits(s[i..j])
        {
            sum := sum + s[j] - '0';
            if sum == j - i {
                count := count + 1;
            }
        }
    }
}

function SumDigits(s: string) : int
{
    var sum := 0;
    for c in s
    {
        sum := sum + c - '0';
    }
    return sum;
}

function CountValidSubstrings(s: string) : int
{
    var count := 0;
    for i := 0 to |s|
        invariant 0 <= i <= |s|
        invariant count == CountValidSubstrings(s[..i])
    {
        for j := i to |s|
            invariant i <= j <= |s|
            invariant count == CountValidSubstrings(s[..j])
        {
            if SumDigits(s[i..j]) == j - i {
                count := count + 1;
            }
        }
    }
    return count;
}