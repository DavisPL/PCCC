function HasTwoOrMoreConsecutiveDots(path: string): bool
  decreases |path|
{
  if |path| < 2 then
    false
  else
    (path[0] == '.' && path[1] == '.')
    || HasTwoOrMoreConsecutiveDots(path[1..])
}

method ContainsTwoOrMoreDots(path: string) returns (contains: bool)
 requires |path| > 0
 ensures contains <==> HasTwoOrMoreConsecutiveDots(path)
{
  contains := HasTwoOrMoreConsecutiveDots(path);
}

method TestHasTwoOrMoreConsecutiveDots() 
{
  // 1. Empty or single dot
  assert HasTwoOrMoreConsecutiveDots([]) == false;
  assert HasTwoOrMoreConsecutiveDots(['.']) == false;

  // 2. Exactly two dots
  assert HasTwoOrMoreConsecutiveDots(['.', '.']) == true;
  assert HasTwoOrMoreConsecutiveDots("..") == true;

  // 3. Three or more consecutive dots
  assert HasTwoOrMoreConsecutiveDots("...") == true;
  // If there are 3 dots in a row, then there's definitely a pair of dots.

  // 4. Dots not consecutive
  assert HasTwoOrMoreConsecutiveDots(". . .") == false;
    // This has single dots separated by spaces, so no two consecutive '.'.

  // 5. Mixed in text
  assert HasTwoOrMoreConsecutiveDots("foo..bar") == true; 
    // "foo" '.' '.' "bar"
  assert HasTwoOrMoreConsecutiveDots("foo.bar") == false;

  // 6. Check the wrapper method matches the function
  var v1 := ContainsTwoOrMoreDots("no.consecutive");
  assert v1 == false;
  var v2 := ContainsTwoOrMoreDots("yes...here");
  assert v2 == true;
  var v3 := ContainsTwoOrMoreDots("yes..../.../here");
  assert v3 == true;
  var v4 := ContainsTwoOrMoreDots("yes/.../here");
}