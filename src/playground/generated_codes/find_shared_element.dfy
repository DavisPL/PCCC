method FindSharedElements(arr1: array<int>, arr2: array<int>) returns (shared: array<int>)
{
  var temp: seq<int> := [];
  for i: int := 0 to arr1.Length - 1
  {
    for j: int := 0 to arr2.Length - 1
    {
      if arr1[i] == arr2[j] && !temp.Contains(arr1[i])
      {
        temp := temp + [arr1[i]];
      }
    }
  }
  shared := new int[temp.Length];
  for k: int := 0 to temp.Length - 1
  {
    shared[k] := temp[k];
  }
}