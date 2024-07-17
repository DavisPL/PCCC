predicate IsDigit(c: char)
{
    48 <= c as int <= 57
}

function SumOfDigits(s: string): int
{
    if |s| == 0 then 0 else (s[0] as int - 48) + SumOfDigits(s[1..])
}

predicate SumEqualsLength(s: string)
{
    IsDigit(s[|s|-1]) && SumOfDigits(s) == |s|
}

method CountSubsWithSumEqualsLength(s: string) returns (count: int)
    ensures count >= 0
    ensures count == | set sub: string | (exists i, j :: 0 <= i <= j < |s| && sub == s[i..j] && SumEqualsLength(sub)) |
{
    count := 0;
    for i in 0..|s| {
        for j in i..|s| {
            if SumEqualsLength(s[i..j]) {
                count := count + 1;
            }
        }
    }
}