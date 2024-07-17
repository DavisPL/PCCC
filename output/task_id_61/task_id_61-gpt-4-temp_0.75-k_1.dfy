predicate IsDigit(c: char)
{
    48 <= c as int <= 57
}

method CountSubstringsWithSumEqualToLength(s: string) returns (count: int)
    requires forall i :: 0 <= i < |s| ==> IsDigit(s[i])
    ensures count >= 0
    ensures count == | set i, j: int | 0 <= i <= j < |s| && SumOfDigits(s[i..j+1]) == j - i + 1 |
{
    count := 0;
    for i := 0 to |s|
        invariant 0 <= i <= |s|
        invariant count == | set k, l: int | 0 <= k <= l < i && SumOfDigits(s[k..l+1]) == l - k + 1 |
    {
        var sum := 0;
        for j := i to |s|
            invariant i <= j <= |s|
            invariant sum == SumOfDigits(s[i..j])
        {
            if sum == j - i {
                count := count + 1;
            }
            if j < |s| {
                sum := sum + s[j] as int - 48;
            }
        }
    }
}

function SumOfDigits(s: string): int
    requires forall i :: 0 <= i < |s| ==> IsDigit(s[i])
{
    if |s| == 0 then 0 else (s[0] as int - 48) + SumOfDigits(s[1..])
}