predicate IsDigit(c: char) {
    48 <= c as int <= 57
}

function SumOfDigits(s: seq<int>): int {
    if |s| == 0 then 0 else s[0] + SumOfDigits(s[1..])
}

method CountSubstrings(s: string) returns (count: int)
    ensures count >= 0
    ensures count == | set i, j : int | 0 <= i <= j < |s| && SumOfDigits(seq(j - i + 1, k => (s[i + k] as int) - 48)) == j - i + 1 |
{
    count := 0;
    for i in 0 .. |s| {
        for j in i .. |s| {
            if SumOfDigits(seq(j - i + 1, k => (s[i + k] as int) - 48)) == j - i + 1 {
                count := count + 1;
            }
        }
    }
}