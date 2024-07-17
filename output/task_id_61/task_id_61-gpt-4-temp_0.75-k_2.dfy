predicate IsDigit(c: char) 
    {
        48 <= c as int <= 57
    }

    method CountSubstrings(s: string) returns (count: int)
        ensures count >= 0
    {
        count := 0;
        for i := 0 to |s|
            invariant 0 <= i <= |s|
            invariant count == | set j: int | 0 <= j <= i && SubstringDigitSumEqualsLength(s, j, i) |
        {
            for j := 0 to i
                invariant 0 <= j <= i
                invariant count == | set k: int | 0 <= k <= j && SubstringDigitSumEqualsLength(s, k, i) |
            {
                if SubstringDigitSumEqualsLength(s, j, i) {
                    count := count + 1;
                }
            }
        }
    }

    predicate SubstringDigitSumEqualsLength(s: string, start: int, end: int)
        requires 0 <= start <= end <= |s|
    {
        var sum := 0;
        for i := start to end
            invariant start <= i <= end
            invariant sum == seq.Sum(seq.Map(c => c as int - 48, seq.Filter(c => IsDigit(c), s[start..i])))
        {
            if IsDigit(s[i]) {
                sum := sum + (s[i] as int - 48);
            } 
        }
        sum == (end - start)
    }