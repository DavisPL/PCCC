method FindMax(a: array<int>) returns (max: int)
	requires 0 < a.Length
	ensures forall k :: 0 < k < a.Length ==> max >= a[k]
	ensures exists k :: (0 < k < a.Length ==> max == a[k])
{
	var index := 0;
	max := a[0]; // assume first is max
	while index < a.Length
		invariant 0 <= index <= a.Length
		invariant forall k :: 0 <= k < index ==> max >= a[k]
	{
		if a[index] >= max { max := a[index]; }
		index := index + 1;
	}
}