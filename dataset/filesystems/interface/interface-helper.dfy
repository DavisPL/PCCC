const dirMaxLength := 4096
const fileMaxLength := 255
const fileMinLength := 4
const validFileCharacters := {'.', '-'}
const validDirCharacters := {'_', '.', '-', '/'}

// Constants for sensitive paths and files
const invalidFileTypes :=  [".php", "CON", "PRN", "AUX", "NUL", "COM1", "COM2", "COM3", "COM4", "LPT1", "LPT2", "LPT3", "LPT4", "LPT5", "LPT6", "LPT7", "LPT8", "LPT9"]
const sensitivePaths := ["/usr", "/System", "/bin", "/sbin", "/var", "/usr/local"]
const currWDir := ["/Users/pari/pcc-llms/src/playground"]
const nonSensitiveFilesList := ["public-key.txt", "safeFile-1.txt", "safeFile-2.txt", "safeFile-3.txt", "bar.txt", "baz.txt"]
// TODO: Define a new datatype for path (os.path type is a string)
// TODO: Add constant values for CWD and everytime get.cwd is called it should check the value be the same


predicate alpha_numeric(c: char)

{
    (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || (c >= '0' && c <= '9')
}


predicate validate_char(c: char)
ensures validate_char(c) <==> alpha_numeric(c) || c in validDirCharacters
{
    alpha_numeric(c) || c in validDirCharacters

}

predicate validate_file_char(c: char)
ensures validate_file_char(c) <==> alpha_numeric(c) || c in validFileCharacters
{
    alpha_numeric(c) || c in validFileCharacters
}

predicate validate_dir_char(c: char)
ensures validate_dir_char(c) <==> alpha_numeric(c) || c in validDirCharacters
{
    alpha_numeric(c) || c in validDirCharacters
}

method ValidateNonsensitiveFile(fileName: seq<char>, nonSensitiveFilesList: seq<seq<char>>) returns (result: bool)
requires 0 < |fileName| <= fileMaxLength
ensures result <==> (exists i :: 0 <= i < |nonSensitiveFilesList| && fileName == nonSensitiveFilesList[i]) || fileName in nonSensitiveFilesList
{
  var res := ContainsSequence(nonSensitiveFilesList, fileName);

    if res {
        result := true;
    } else {
        result := false;
    }
}



function string_slice(s: seq<char>): seq<char>
{
  if |s| == 0 then "" else ([s[|s| - 1]] + string_slice(s[..(|s| - 1)]))
}

lemma StringSliceLemma(s: seq<char>)
requires 0 <= |s|
ensures forall i:: 0 <= i < |s| ==> s[..(i+1)] == s[..i] + [s[i]]
{
    assert |s| == 0 || |s| > 0;
    assert forall i:: 0 <= i < |s| ==> s[..(i+1)] == s[..i] + [s[i]];
}

function concat(s1: seq<char>, s2: seq<char>): seq<char>
requires 0 <= |s1| + |s2| && 0 < |s1| <= dirMaxLength - fileMaxLength && 0 < |s2| <= fileMaxLength
ensures |concat(s1, s2)| == |s1| + |s2| && concat(s1, s2) == s1 + s2 && |s1| + |s2| <= dirMaxLength 
{
  s1 + s2
}

function path_join(s1: seq<char>, s2: seq<char>): seq<char>
requires 0 <= |s1| + |s2| && 0 < |s1| <= dirMaxLength - fileMaxLength - 1 && 0 < |s2| <= fileMaxLength
ensures |concat(concat(s1, "/"), s2)| == |s1| + |s2| + 1 && concat(concat(s1, "/"), s2) == s1 + "/" + s2 && |s1| + |s2| <= dirMaxLength 
{
  if s1[|s1| - 1] == '/' then  concat(s1, s2) else concat(concat(s1, "/"), s2)
}


predicate has_path_traversal(s: seq<char>)
ensures has_path_traversal(s) <==> exists i :: 0 <= i < |s| && is_traversal_pattern(s, i)
{
    exists i :: 0 <= i < |s| && is_traversal_pattern(s, i)
}

predicate is_traversal_pattern(s: seq<char>, i: int)
requires 0 <= i < |s|
{
    (i + 2 < |s| && s[i] == '.' && s[i+1] == '.' && (s[i+2] == '/' || s[i+2] == '\\')) ||
    (i + 5 < |s| && s[i..i+6] == ['%', '2', 'e', '%', '2', 'e']) ||
    (i + 8 < |s| && s[i..i+9] == ['%', '2', '5', '2', 'e', '%', '2', '5', '2', 'e']) ||
    (i > 0 && s[i-1] == '/' && i + 2 < |s| && s[i] == '.' && s[i+1] == '.' && s[i+2] == '.')
}

predicate is_dangerous_path(s: seq<char>)
ensures is_dangerous_path(s) <==> has_path_traversal(s) || has_absolute_path(s)
{
    has_path_traversal(s) || has_absolute_path(s)
}

predicate has_absolute_path(s: seq<char>)
ensures has_absolute_path(s) <==> |s| > 0 && (s[0] == '/' || (|s| > 1 && s[1] == ':'))
{
    |s| > 0 && (s[0] == '/' || (|s| > 1 && s[1] == ':'))
}



predicate validate_file(fileName: seq<char>)
requires 0 <= |fileName| <= fileMaxLength
ensures validate_file(fileName) <==> forall i :: 0 <= i < |fileName|  ==> validate_file_char(fileName[i]) && alpha_numeric(fileName[0]) && alpha_numeric(fileName[|fileName| - 1])
{
  forall i :: 0 <= i < |fileName| ==> validate_file_char(fileName[i]) && alpha_numeric(fileName[0]) && alpha_numeric(fileName[|fileName| - 1])

}



predicate validate_dir_name(dirName: seq<char>)
requires 0 <= |dirName| <= dirMaxLength
  ensures validate_dir_name(dirName) <==> forall i :: 0 <= i < |dirName| ==> validate_char(dirName[i])
{
  forall i :: 0 <= i < |dirName| ==> validate_char(dirName[i])
}

method ValidateFileType(fileType: seq<char>) returns (result: bool)
requires 0 <= |fileType| <= 4
{
  var res := ContainsSequence(nonSensitiveFilesList, fileType);
  if !res {
    result := true;
  } else {
    result := false;
  }
}

method ContainsC(s: string, c: char) returns (result: bool)
  requires 'a' <= c <= 'z' || 'A' <= c <= 'Z' || '0' <= c <= '9'
  ensures result <==> (exists i :: 0 <= i < |s| && (s[i] == c)) || c in s
{
  result := false;
  var i := 0;
  while i < |s|
    invariant 0 <= i <= |s|
    invariant result <==> (exists k :: 0 <= k < i && (s[k] == c))
  {
    if s[i] == c {
      assert c in s;
      result := true;
      break;
    }
    assert result <==> (exists k :: 0 <= k < i && (s[k] == c));
    i := i + 1; 

  }

}

method ContainsSequence(list: seq<seq<char>>, sub: seq<char>) returns (result: bool)
  ensures result <==> (exists i :: 0 <= i < |list| && sub == list[i]) || sub in list
{
  result := false;
  for i := 0 to |list|
    invariant 0 <= i <= |list|
    invariant result <==> (exists k :: 0 <= k < i && sub == list[k])
  {
    if sub == list[i] {
      result := true;
      break;
    }
  }
}

predicate is_lower_case(c : char)
{
    97 <= c as int <= 122
}

predicate is_lower_upper_pair(c : char, C : char)
{
    (c as int) == (C as int) + 32
}

function shift_minus32(c : char) :  char
{
    ((c as int - 32) % 128) as char
}

method ToUppercase(s: string) returns (v: string)
    ensures |v| == |s|
    ensures forall i :: 0 <= i < |s| ==>  if is_lower_case(s[i]) then is_lower_upper_pair(s[i], v[i]) else v[i] == s[i]
{
    var s' : string := [];
    for i := 0 to |s|
    invariant 0 <= i <= |s|
    invariant |s'| == i
    invariant forall k :: 0 <= k < i &&  is_lower_case(s[k]) ==> is_lower_upper_pair(s[k], s'[k])
    invariant forall k :: 0 <= k < i && !is_lower_case(s[k]) ==> s[k] == s'[k]
    {
        if is_lower_case(s[i])
        {
            s' := s' + [shift_minus32(s[i])];
        }
        else 
        {
            s' := s' + [s[i]];
        }
    }
    return s';
}


method ArrayFromSeq<A>(s: seq<A>) returns (a: array<A>)
// Convert a string to an array of characters
  ensures a[..] == s
{
  a := new A[|s|] ( i requires 0 <= i < |s| => s[i] );
}

function digit_to_char(n: nat): char
// Compute the character representation of a digit
  requires 0  <= n <=  9
  ensures '0' <= digit_to_char(n) <= '9'
{
  '0' + n as char // `as` is the type-casting operator
}

function number_to_string(n: nat): string
// Convert a number to its string representation
  ensures forall i :: 0 <= i < |number_to_string(n)| ==> '0' <= number_to_string(n)[i] <= '9'
{
  if n < 10
  // Base case: A nat on [0, 10) is just one character long.
  then [digit_to_char(n)]
  // Inductive case: Compute all but the last character, then append the final one at the end
  else number_to_string(n/10) + [digit_to_char(n % 10)]
}


method ComputeDigitToChar(n: nat) returns (result: char)
// Compute the character representation of a digit
  requires 0  <= n <=  9
  ensures '0' <= result <= '9'
  ensures result == digit_to_char(n)
{
  return '0' + n as char;
}

method ComputeNumberToString(n: nat) returns (r: string)
// Compute the string representation of a number
  ensures r == number_to_string(n)
{
  if n < 10 {
    var digit_to_char := ComputeDigitToChar(n);
    r := [digit_to_char];
  }

  else {
    var numToChar := ComputeNumberToString(n/10);
    var digit_to_char := ComputeDigitToChar(n % 10);
    r := numToChar + [digit_to_char];
  }

}

function char_to_byte(c: char): int 
// Convert a character to a byte
{
  c as int
}


method StringToBytes(s: string) returns (bytesSeq: seq<int>)
// Convert a string to a sequence of bytes<int>
  requires |s| > 0  // Precondition requires non-empty strings
  ensures |s| == |bytesSeq|  //  // Postcondition ensure the length of the generated sequence matches the input string length
  ensures forall i: int :: 0 <= i < |s| ==> bytesSeq[i] == s[i] as int  // Each byte should match the character in s
{
  bytesSeq := [];
  var i := 0;
  while i < |s|
    invariant 0 <= i <= |s|
    invariant |bytesSeq| == i  // Ensure that the length of bytesSeq matches the number of iterations
    invariant forall j: int :: 0 <= j < i ==> bytesSeq[j] == s[j] as int  // Each element up to i matches the string's character.
  {
    bytesSeq := bytesSeq + [char_to_byte(s[i])];
    i := i + 1;  // Increment the index to move to the next character.
  }

}
function contains_sequence(list: seq<seq<char>>, sub: seq<char>): bool
  ensures contains_sequence(list, sub) <==> (exists i :: 0 <= i < |list| && sub == list[i])
{
  if |list| == 0 then
    false
  else if sub == list[0] then
    true
  else
    contains_sequence(list[1..], sub)
}

function contains_char(s: string, c: char): bool
  requires 'a' <= c <= 'z' || 'A' <= c <= 'Z' || '0' <= c <= '9'
{
  exists i :: 0 <= i < |s| && s[i] == c
}

lemma CharAtIndexImpliesContainsC(s: string, c: char, index: int)
  requires 'a' <= c <= 'z' || 'A' <= c <= 'Z' || '0' <= c <= '9'
  requires 0 <= index < |s|
  requires s[index] == c
  ensures contains_char(s, c)
{
  // The body can be empty; Dafny can prove this automatically
}

method ContainsCharMethod(s: string, c: char) returns (result: bool)
  requires 'a' <= c <= 'z' || 'A' <= c <= 'Z' || '0' <= c <= '9'
  ensures result == contains_char(s, c)
{
  result := false;
  var i := 0;
  while i < |s|
    invariant 0 <= i <= |s|
    invariant result == (exists k :: 0 <= k < i && s[k] == c)
  {
    if s[i] == c {
      CharAtIndexImpliesContainsC(s, c, i);
      result := true;
      return;
    }
    i := i + 1;
  }
}
// method GetFileType(fileName: seq<char>) returns (fileType: seq<char>)
// requires 0 < |fileName| <= fileMaxLength
// ensures 0 <= |fileType| <= 3
// ensures 0 <= |fileType| < 4
// ensures forall j :: 0 <= j < |fileType| ==> validate_file_char(fileType[j])
// {
//   fileType := [];
//   var i := |fileName| - 1;
//   while i > 0
//     invariant 0 <= i <= |fileName|
//     invariant 0 <= |fileType| < 4
//     invariant forall j :: 0 <= j < |fileType| ==> validate_file_char(fileType[j])
//   {
//     if fileName[i] == '.' {
//       break;
//     }
//     fileType := [fileName[i]] + fileType;
//     i := i - 1;
//   }
// }