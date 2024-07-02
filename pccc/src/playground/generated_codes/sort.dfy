method FindSharedElements(arr1: array<int>, arr2: array<int>) returns (result: array<int>)
{
  var temp: seq<int> := [];
  if arr1.Length > 0 && arr2.Length > 0 {
    for i := 0 to arr1.Length - 1
    {
      var element := arr1[i];
      var found := false;
      for j := 0 to arr2.Length - 1
      {
        if arr2[j] == element
        {
          found := true;
          break;
        }
      }
      if found {
        var alreadyIncluded := false;
        if |temp| > 0 {
          for k := 0 to |temp| - 1
          {
            if temp[k] == element
            {
              alreadyIncluded := true;
              break;
            }
          }
        }
        if !alreadyIncluded
        {
          temp := temp + [element];
        }
      }
    }
  }
  result := new int[|temp|];
  if |temp| > 0 {
    for i := 0 to |temp| - 1
    {
      result[i] := temp[i];
    }
  }
}