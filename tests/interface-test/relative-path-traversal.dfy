function HasDotDotSlash(path: seq<char>): bool
  decreases |path|
{
  if |path| < 3 then
    false
  else
    (path[0] == '.' && path[1] == '.' && path[2] == '/')
    || HasDotDotSlash(path[1..])
}

method ContainsDotDotForwardSlash(path: seq<char>) returns (contains: bool)
  ensures contains <==> HasDotDotSlash(path)
{
  // Implement via loop, or trivially:
  contains := HasDotDotSlash(path);
}

 function HasDotDotBackslash(path: seq<char>): bool
    decreases |path|
    {
    if |path| < 3 then
        false
    else
        (path[0] == '.' && path[1] == '.' && path[2] == '\\')
        || HasDotDotBackslash(path[1..])
    }

    method ContainsDotDotBackslash(path: seq<char>) returns (contains: bool)
    ensures contains <==> HasDotDotBackslash(path)
    {
        contains := HasDotDotBackslash(path);
    }

    function HasSlashDotDot(path: seq<char>): bool
    decreases |path|
    {
    if |path| < 3 then
        false
    else
        (path[0] == '/' && path[1] == '.' && path[2] == '.')
        || HasSlashDotDot(path[1..])
    }

    method ContainsSlashDotDot(path: seq<char>) returns (contains: bool)
    ensures contains <==> HasSlashDotDot(path)
    {
        contains := HasSlashDotDot(path);
    }



function HasBackslashDotDot(path: seq<char>): bool
  decreases |path|
{
  if |path| < 3 then
    false
  else
    (path[0] == '\\' && path[1] == '.' && path[2] == '.')
    || HasBackslashDotDot(path[1..])
}

method ContainsBackslashDotDot(path: seq<char>) returns (contains: bool)
  ensures contains <==> HasBackslashDotDot(path)
{
  contains := HasBackslashDotDot(path);
}

// "Test" method in Dafny style: we put various assertions.
method TestHasDotDotSlash() 
{
  // 1. Too short to contain "../"
  assert HasDotDotSlash([]) == false;
  assert HasDotDotSlash(['.']) == false;
  assert HasDotDotSlash(['.', '.']) == false;

  // 2. Exactly "../"
  assert HasDotDotSlash(['.', '.', '/']) == true;

  // 3. No slash after dots
  assert HasDotDotSlash("foo..bar") == false; 
    // "foo..bar" => no substring "../".

  // 4. Has "../" at the beginning
  assert HasDotDotSlash("../hello") == true;

  // 5. Has "../" in the middle
  assert HasDotDotSlash("foo../../bar") == true;
    // At index 3..5 we see ".", ".", "/".

  // 6. Overlapping dots
  assert HasDotDotSlash(".../") == true;
    // At index 1..3 => '.', '.', '/'.

  // 7. Mixed text around
  var s := "hello../world";
  // "h(0)e(1)l(2)l(3)o(4).(5).(6)/(7)w(8)o(9)r(10)l(11)d(12)"
  // There's "../" at index 5..7. 
  assert HasDotDotSlash(s) == true;
 assert HasDotDotSlash(".../") == true;
// path[1..3] => '.', '.', '/' => "../"
 // Not enough chars:
  assert HasDotDotBackslash([]) == false;
  assert HasDotDotBackslash("..") == false;

  // Exactly "..\"
  assert HasDotDotBackslash(['.', '.', '\\']) == true;

  // Found in the middle
  assert HasDotDotBackslash("foo..\\bar") == true;
  assert HasDotDotBackslash("foobar") == false;  


  // ========== HasSlashDotDot ("/..") ==========

  // Not enough chars:
  assert HasSlashDotDot("/") == false;

  // Exactly "/.."
  assert HasSlashDotDot(['/', '.', '.']) == true;

  // Found in the middle
  assert HasSlashDotDot("foo/..bar") == true;
  assert HasSlashDotDot("foo...bar") == false;
    // "..." does not count as "/.."


  // ========== HasBackslashDotDot ("\..") ==========

  // Not enough chars:
  assert HasBackslashDotDot("\\") == false;

  // Exactly "\.."
  assert HasBackslashDotDot(['\\', '.', '.']) == true;

  // Found in the middle
  assert HasBackslashDotDot("foo\\..bar") == true;
  assert HasBackslashDotDot("foo...bar") == false;
    // "..." does not count as "\.."
}