method CountSubstringsWithEqualSumAndLength(s: string) returns (count: int)
    ensures count >= 0
    ensures count == | set i: int, j: int | 0 <= i <= j <= |s| && IsSubstringSumEqualLength(s, i, j) |
{
    count := 0;
    for i := 0 to |s|
        invariant 0 <= i <= |s|
        invariant count == | set j: int | i <= j <= |s| && IsSubstringSumEqualLength(s, i, j) |
    {
        for j := i to |s|
            invariant i <= j <= |s|
            invariant count == | set k: int | i <= k <= j && IsSubstringSumEqualLength(s, i, j) |
        {
            if IsSubstringSumEqualLength(s, i, j) {
                count := count + 1;
            }
        }
    }
}

function IsSubstringSumEqualLength(s: string, start: int, end: int) : bool
{
    var sum := 0;
    for k := start to end
        invariant start <= k <= end
        invariant sum == SumOfDigitsSubstring(s, start, k)
    {
        sum := sum + (s[k] - '0');
    }
    return sum == end - start + 1;
}

function SumOfDigitsSubstring(s: string, start: int, end: int) : int
{
    var sum := 0;
    for i := start to end
        invariant start <= i <= end
        invariant sum == SumOfDigitsSubstring(s, start, i)
    {
        sum := sum + (s[i] - '0');
    }
    return sum;
}