predicate IsDigit(c: char)
{
    48 <= c as int <= 57
}

function DigitValue(c: char): int
    requires IsDigit(c)
{
    c as int - 48
}

method CountSubstrings(s: string) returns (count: int)
    ensures count >= 0
    ensures count == | set i, j: int | 0 <= i <= j < |s| && SumDigits(s, i, j) == j - i + 1|
{
    count := 0;
    for i in 0..|s|
        invariant 0 <= i <= |s|
        invariant count == | set k, l: int | 0 <= k <= l < i && SumDigits(s, k, l) == l - k + 1|
    {
        for j in i..<|s|
            invariant i <= j < |s|
            invariant count == | set k, l: int | 0 <= k <= l <= j && SumDigits(s, k, l) == l - k + 1|
        {
            if SumDigits(s, i, j) == j - i + 1 {
                count := count + 1;
            }
        }
    }
}

function SumDigits(s: string, start: int, end: int): int
    requires 0 <= start <= end < |s|
    requires forall i: int :: start <= i <= end ==> IsDigit(s[i])
    reads s
{
    if start > end then 0
    else DigitValue(s[start]) + SumDigits(s, start + 1, end)
}