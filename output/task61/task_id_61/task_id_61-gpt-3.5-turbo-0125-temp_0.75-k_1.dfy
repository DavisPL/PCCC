method CountSubstringsWithSumEqualLength(s: string) returns (count: int)
    requires s != null
    ensures count >= 0
    ensures count == CountSubstringsSumEqualLength(s)
{
    count := 0;
    var n := |s|;
    for i := 0 to n
        invariant 0 <= i <= n
        invariant count == CountSubstringsSumEqualLength(s[..i])
    {
        for j := i+1 to n
            invariant i < j <= n
            invariant count == CountSubstringsSumEqualLength(s[..i])
        {
            var sub := s[i..j];
            if SumDigits(sub) == |sub| {
                count := count + 1;
            }
        }
    }
}