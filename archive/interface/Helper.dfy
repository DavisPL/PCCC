type path = seq<char>
type file = seq<char>
type fileType = seq<char>
const pathMaxLength :int  := 1024 // Maximum length of a path for UNIX Systems
const fileMaxLength :int := 50
const fileMinLength :int := 4
const fileMaxSize :int32 := 0x79999999 // Maximum file size
const validFileCharacters := {'-', '_', '.', '(', ')', ' ', '%'}
const validPathCharacters := {'~','-', '_', '.', '(', ')', ' ', '%', '/'}

newtype{:nativeType "byte"} byte = i:int | 0 <= i < 0x100
newtype{:nativeType "int"} int32 = i:int | -0x80000000 <= i < 0x80000000
newtype{:nativeType "int"} nat32 = i:int | 0 <= i < 0x80000000
newtype{:nativeType "int"} maxPath = i:int | 0 <= i < 256
newtype nat64 = i:int | 0 <= i < 0x10000000000000000
datatype PathOrFile = Path(p: seq<char>) | File(f: seq<char>)
// Constants for sensitive paths and files
const invalidFileTypes :=  ["php", "CON", "PRN", "AUX", "NUL", "COM1", "COM2", "COM3", "COM4", "LPT1", "LPT2", "LPT3", "LPT4", "LPT5", "LPT6", "LPT7", "LPT8", "LPT9"]
const sensitivePaths := ["/id_rsa","/usr", "/System", "/bin", "/sbin", "/var", "/usr/local", "/documnets", "/etc/passwd"]
const currWDir := ["/Users/pari/pcc-llms/src/playground"]
const allowedServices: map<string, seq<string>> := map[
    "apache" := ["access.log", "error.log"],
    "mysql" := ["query.log", "slow.log"],
    "ssh" := ["auth.log"]
    // Add more services and their allowed log files as needed
]
// const SensitiveFilesList : seq<seq<char>> := ["~/id_rsa.pub","/user-data/shared-data.txt",
// "/user-data/public-info.txt", "/user-data/public-key.txt","shared-data.txt","public-info.txt", 
// "/company-docs/instructions.txt", "/company-docs/public-info.txt", "/company-docs/employee-handbook.txt", "company-docs/annual-report.txt",
// "public-key.txt", "safeFile-1.txt", "safeFile-2.txt", "safeFile-3.txt", "bar.txt", "baz.txt"]
 // Set of allowed file extensions
const allowedExtensionsForRead: seq<string> := ["txt", "pdf", "docx"]
const allowedExtensionsForWrite: seq<string> := ["txt", "docx"]
datatype Permission = Read | Write | Execute
type User = seq<char>


predicate alpha_numeric(c: char)
ensures alpha_numeric(c) == ((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || (c >= '0' && c <= '9'))
{
    (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || (c >= '0' && c <= '9')
}

predicate is_alpha_numeric(s: string)
{
    forall c :: c in s ==> alpha_numeric(c)
}

predicate is_drive_letter(c: char)
{
    ('a' <= c <= 'z') || ('A' <= c <= 'Z')
}

predicate is_valid_char(c: char)
ensures is_valid_char(c) <==> alpha_numeric(c) || c in validPathCharacters
{
    alpha_numeric(c) || c in validPathCharacters

}

predicate is_file_valid_char(c: char)
ensures is_file_valid_char(c) <==> alpha_numeric(c) || c in validFileCharacters
{
    alpha_numeric(c) || c in validFileCharacters
}

 predicate is_valid_file_name(filename: string)
{
    forall i :: 0 <= i < |filename| ==> is_file_valid_char(filename[i])
}

predicate is_valid_path_char(c: char)
{
    alpha_numeric(c) || c in validPathCharacters
}

 predicate is_valid_path_name(path: string)
{
    forall i :: 0 <= i < |path| ==> is_valid_path_char(path[i])
}


predicate has_valid_file_length(f: file)
{
  0 < |f| < fileMaxLength
}

predicate is_valid_str_length(content: string )
{
  -0x80000000 <= |string_to_bytes(content)| < 0x80000000
}

predicate has_valid_content_length(content: array<byte>)
{
  -0x80000000 <= content.Length < 0x80000000
}

predicate is_valid_dir_char(c: char)
ensures is_valid_dir_char(c) <==> alpha_numeric(c) || c in validPathCharacters
{
    alpha_numeric(c) || c in validPathCharacters
}

predicate is_valid_dir(p: path)
requires 0 <= |p| <= pathMaxLength
ensures is_valid_dir(p) <==> forall i :: 0 <= i < |p| ==> is_valid_char(p[i])
{
  forall i :: 0 <= i < |p| ==> is_valid_char(p[i])
}

predicate has_valid_path_length(p: path)
{
   0 <= |p| < pathMaxLength
}

// predicate HasValidPathFileLength(PathOrFile: PathOrFile)
// {
//   match PathOrFile
//   {
//     case Path(p) => 0 < |p| <= pathMaxLength
//     case File(f) => 0 < |f| <= fileMaxLength
//   }
// }

predicate validate_file_type(f: file)
  ensures validate_file_type(f) <==> (get_file_extension(f) in allowedExtensionsForRead
   && get_file_extension(f) !in invalidFileTypes)
{
  var extension := get_file_extension(f);
  if (extension in allowedExtensionsForRead  && extension !in invalidFileTypes) then true else false
}

  // Function to check if filename has leading or trailing spaces
function no_leading_trailing_space(filename: string): bool
requires |filename| > 0
{
    StringSliceLemma(filename);
    filename[0] != ' ' && filename[|filename|-1] != ' '
}

  // Function to check if filename starts with a period
function no_period_at_start(filename: string): bool
requires |filename| > 0
{
    filename[0] != '.'
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
requires 0 <= |s1| + |s2| <= pathMaxLength && 0 <= |s1| && 0 <= |s2|
ensures |concat(s1, s2)| == |s1| + |s2| && concat(s1, s2) == s1 + s2 && 0 <= |s1| + |s2| <= pathMaxLength 
{
  s1 + s2
}

predicate joint_path_length(p: path, f: file)
requires 0 < |p| < pathMaxLength && 0 < |f| < fileMaxLength && 0 < |p| + |f| < pathMaxLength
requires 0 < get_path_length(PathOrFile.File(f)) <= fileMaxLength && 0 < get_path_length(PathOrFile.Path(p)) <= pathMaxLength 
&&  get_path_length(PathOrFile.Path(p)) + get_path_length(PathOrFile.File(f)) <= pathMaxLength
requires 0 < |p| < pathMaxLength && 0 < |f| < fileMaxLength && 0 < |p| + |f| < pathMaxLength
requires 0 < get_path_length(PathOrFile.File(f)) <= fileMaxLength && 0 < get_path_length(PathOrFile.Path(p)) <= pathMaxLength 
&&  get_path_length(PathOrFile.Path(p)) + get_path_length(PathOrFile.File(f)) <= pathMaxLength
{
  0 < get_path_length(PathOrFile.File(f)) <= fileMaxLength && 0 < get_path_length(PathOrFile.Path(p)) <= pathMaxLength 
  &&  get_path_length(PathOrFile.Path(p)) + get_path_length(PathOrFile.File(f)) <= pathMaxLength
}

function append_file_to_path(p: path, f: file): seq<char>
requires 0 < |p| + |f| <= pathMaxLength - 1 && 0 <= |p| && 0 < |f| 
ensures |append_file_to_path(p, f )| <= pathMaxLength
ensures |concat(concat(p, "/"), f)| == |p| + |f| + 1 && 
        concat(concat(p, "/"), f) == p + "/" + f && |p| + |f| <= pathMaxLength 
ensures (append_file_to_path(p, f) == concat(p, f) || append_file_to_path(p, f) == concat(concat(p, "/"), f))
{
  if |p| == 0 then f else if p[|p| - 1] == '/' then  concat(p, f) else concat(concat(p, "/"), f)
}


function get_path_length(pof: PathOrFile): nat
{
  match pof
  {
    case Path(p) => |p|
    case File(f) => |f|
  }
}


predicate has_dangerous_pattern(p: path)

{
    contains_consecutive_periods(p) || !has_absolute_path(p) ||
    contains_encoded_periods(p)
    || contains_dangerous_pattern(p)
}

predicate has_absolute_path(p: path)
ensures has_absolute_path(p) <==> |p| > 0 && (p[0] == '/' || (|p| > 1 && p[1] == ':') || (|p| > 2 && is_valid_char(p[2])))
{
    |p| > 0 && (p[0] == '/' || (|p| > 1 && p[1] == ':') || (|p| > 2 && is_valid_char(p[2])))
}

predicate is_unix_absolute_path(p: path)
ensures is_unix_absolute_path(p) == (|p| > 0 && p[0] == '/')
{
    |p| > 0 && p[0] == '/'
}

predicate is_windows_absolute_path(p: path)
  ensures is_windows_absolute_path(p) == (
      // Drive letter paths like "C:\"
      (|p| >= 3 && is_drive_letter(p[0]) && p[1] == ':' && (p[2] == '\\' || p[2] == '/')) ||
      // Drive letter paths like "C:"
      (|p| == 2 && is_drive_letter(p[0]) && p[1] == ':') ||
      // UNC paths like "\\server\share"
      (|p| >= 2 && p[0] == '\\' && p[1] == '\\')
  )
{
    var isDrivePathWithSlash := |p| >= 3 && is_drive_letter(p[0]) && p[1] == ':' &&
                                (p[2] == '\\' || p[2] == '/');
    var isDrivePath := |p| == 2 && is_drive_letter(p[0]) && p[1] == ':';
    var isUNCPath := |p| >= 2 && p[0] == '\\' && p[1] == '\\';

    isDrivePathWithSlash || isDrivePath || isUNCPath
}

predicate is_absolute_path(p: path)
  ensures is_absolute_path(p) == (is_unix_absolute_path(p) || is_windows_absolute_path(p))
{
    is_unix_absolute_path(p) || is_windows_absolute_path(p)
}

// / Function to check if a file extension is valid
predicate is_valid_file_extension(filename: string)
    requires |filename| > 0
    ensures is_valid_file_extension(filename) ==>
        exists i :: 0 <= i < |filename| && filename[i] == '.' &&
            (forall j :: i < j < |filename| ==> filename[j] != '/' && filename[j] != '\\') &&
            i < |filename| - 1
{
    var lastDotIndex := find_last_index_c(filename, '.');
    lastDotIndex >= 0 &&
    lastDotIndex < |filename| - 1 &&
    forall i :: lastDotIndex < i < |filename| ==>
        filename[i] != '/' && filename[i] != '\\'
}

// Helper function to get the last index of a character in a sequence
function find_last_index_c(s: seq<char>, c: char): int
  ensures -1 <= find_last_index_c(s, c) < |s|
  ensures find_last_index_c(s, c) > -1 ==> s[find_last_index_c(s, c)] == c
  ensures find_last_index_c(s, c) == -1 ==> forall i :: 0 <= i < |s| ==> s[i] != c
  ensures forall i :: find_last_index_c(s, c) < i < |s| ==> s[i] != c
{
  StringSliceLemma(s);
  LastIndexOfLemma(s, c, |s| - 1)
}

// Recursive helper for LastIndexOf
function LastIndexOfLemma(s: string, c: char, start: int): (result: int)
    requires -1 <= start < |s|
    ensures -1 <= result <= start
    ensures result >= 0 ==> s[result] == c
    ensures result == -1 ==> forall i :: 0 <= i <= start ==> s[i] != c
    ensures forall i :: result < i <= start ==> s[i] != c
    decreases start + 1
{
    if start == -1 || |s| == 0  then -1
    else if s[start] == c then start
    else LastIndexOfLemma(s, c, start - 1)


  //     if |s| == 0 then -1
  // else if s[|s|-1] == c then |s| - 1
  // else find_last_index_c(s[..|s|-1], c)
}

 // Lemma to help prove properties about LastIndexOf
  lemma LastIndexOfPropertiesLemma(s: string, c: char)
      ensures find_last_index_c(s, c) >= 0 ==>
          exists i :: 0 <= i < |s| && s[i] == c &&
          forall j :: i < j < |s| ==> s[j] != c
      ensures find_last_index_c(s, c) == -1 ==>
          forall i :: 0 <= i < |s| ==> s[i] != c
  {
      if |s| == 0 {
          assert find_last_index_c(s, c) == -1;
      } else {
          var lastIndex := find_last_index_c(s, c);
          if lastIndex >= 0 {
              assert s[lastIndex] == c;
              assert forall j :: lastIndex < j < |s| ==> s[j] != c;
          } else {
              assert forall i :: 0 <= i < |s| ==> s[i] != c;
          }
      }
  }

// Helper function to get file extension
function get_file_extension(filename: file): string
{
    var lastDotIndex := find_last_index_c(filename, '.');
    if lastDotIndex == -1 then
      []
    else
      filename[lastDotIndex + 1..]
}

method ValidateFileType(t: fileType) returns (result: bool)
requires 0 <= |t| <= 4
{
  var res := ContainsSequence(sensitivePaths, t);
  if !res {
    result := true;
  } else {
    result := false;
  }
}

method ContainsC(s: string, c: char) returns (result: bool)
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


predicate is_prefix(p1: path, p2: path)
{
  |p1| <= |p2| && p1 == p2[..|p1|]
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
{
  if n < 10
  // Base case: A nat on [0, 10) is just one character long.
  then [digit_to_char(n)]
  // Inductive case: Compute all but the last character, then append the final one at the end
  else number_to_string(n/10) + [digit_to_char(n % 10)]
}


method Compute_digit_to_char(n: nat) returns (result: char)
// Compute the character representation of a digit
  requires 0  <= n <=  9
  ensures '0' <= result <= '9'
  ensures result == digit_to_char(n)
{
  return '0' + n as char;
}

method ConvertNumberToString(n: nat) returns (r: string)
// Compute the string representation of a number
  // ensures r == number_to_string(n)
{
  if n < 10 {
    var digit_to_char := Compute_digit_to_char(n);
    r := [digit_to_char];
  }

  else {
    var numToChar := ConvertNumberToString(n/10);
    var digit_to_char := Compute_digit_to_char(n % 10);
    r := numToChar + [digit_to_char];
  }

}

function char_to_int(c: char): int 
// Convert a character to a byte
{
  c as int
}

function char_to_byte(c: char): byte
// Convert a character to a byte
{
    var i := char_to_int(c);
    if 0 <= i < 0x100 then i as byte else 0 as byte
}

function string_to_bytes(s: string): seq<byte>
{
    if |s| == 0 then
        []
    else
        [char_to_byte(s[0])] + string_to_bytes(s[1..])
}

method StringToSeqInt(s: string) returns (bytesSeq: seq<int>)
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
    bytesSeq := bytesSeq + [char_to_int(s[i])];
    i := i + 1;  // Increment the index to move to the next character.
  }

}

function list_contains_string(list: seq<seq<char>>, sub: seq<char>): bool
{
  if |list| == 0 then
    false
  else if sub == list[0] then
    true
  else
    list_contains_string(list[1..], sub)
}

function ContainsChar(s: string, c: char): bool
{
  exists i :: 0 <= i < |s| && s[i] == c
}

lemma CharAtIndexImpliesContainsC(s: string, c: char, index: int)
  requires alpha_numeric(c)
  requires is_alpha_numeric(s)
  requires 0 <= index < |s|
  requires s[index] == c
  ensures ContainsChar(s, c)
{
  // The body can be empty; Dafny can prove this automatically
}

method ContainsCharMethod(s: string, c: char) returns (result: bool)
  requires alpha_numeric(c)
  requires is_alpha_numeric(s)
  ensures result == ContainsChar(s, c)
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


// Check 1: Path is not empty
predicate non_empty_string(s: string)
  ensures non_empty_string(s) ==> |s| > 0 && s != ""
{
   |s| > 0 && s != ""
}

// Check 3: Path does not contain reserved names
method HasNoReservedNames(path: string) returns (isValid: bool)
{
  var reservedNames := ["CON", "PRN", "AUX", "NUL", "COM1", "COM2", "COM3", "COM4", "LPT1", "LPT2", "LPT3", "LPT4"];
  var upperPath := ToUppercase(path);
  for i := 0 to |reservedNames|
  {
    var startsWithReserved := StartsWith(upperPath, reservedNames[i]+ ".");
    if upperPath == reservedNames[i] || startsWithReserved {
      return false;
    }
  }
  return true;
}

// Helper method: Check if string starts with prefix
method StartsWith(s: string, prefix: string) returns (result: bool)
  requires |prefix| > 0
  ensures result <==> |s| >= |prefix| && s[..|prefix|] == prefix
{
  if |s| < |prefix| {
    return false;
  }

  var i := 0;
  while i < |prefix|
    invariant 0 <= i <= |prefix|
    invariant forall k :: 0 <= k < i ==> s[k] == prefix[k]
  {
    if s[i] != prefix[i] {
      return false;
    }
    i := i + 1;
  }

  return true;
}



predicate contains_consecutive_periods(s: seq<char>)
    decreases s
{
   StringSliceLemma(s);
    if |s| < 2 then
        false
    else if (s[0] == '.' && s[1] == '.') then
        true
    else
        contains_consecutive_periods(s[1..])

}



predicate contains_encoded_periods(s: seq<char>)
    decreases s
{
    StringSliceLemma(s);
    if |s| < 4 then
        false
    else if s[0] == '%' && s[1] == '2' && s[2] == 'e' && s[3] == 'e' then
        true
    else
        contains_encoded_periods(s[1..])

}



    // Check for parent directory traversal (..)
    predicate contains_parent_dir_traversal(s: seq<char>)
        decreases s
    {
        StringSliceLemma(s);
        if |s| < 2 then
            false
        else if s[0] == '.' && s[1] == '.' then
            true
        else
            contains_parent_dir_traversal(s[1..])
    }

    // Check for home directory reference (~)
    predicate contains_home_dir_reference(s: seq<char>)
        decreases s
    {
        StringSliceLemma(s);
        if |s| < 1 then
            false
        else if s[0] == '~' then
            true
        else
            contains_home_dir_reference(s[1..])
    }

    // Check for absolute path (starts with / or \)
    // function StartsWithAbsolutePath(s: seq<char>): bool
    // {
    //     |s| > 0 && (s[0] == '/' || s[0] == '\\')
    // }

    // Check for drive letter (contains :)
    predicate contains_drive_letter(s: seq<char>)
        decreases s
    {
        StringSliceLemma(s);
        if |s| < 1 then
            false
        else if s[0] == ':' then
            true
        else
            contains_drive_letter(s[1..])
    }

    // Main function to detect dangerous patterns
    predicate contains_dangerous_pattern(s: seq<char>)
    {
        contains_parent_dir_traversal(s) ||
        contains_home_dir_reference(s) ||
        // StartsWithAbsolutePath(s) ||
        contains_drive_letter(s)
    }

    

  //   predicate ContainsSymlink(p: string)
  //   requires p != "" && |p| > 0
  //   {
  //     if p == "/" || p == "" then
  //       false
  //     else
  //       var parent := GetParentPath(p);
  //       if IsSymlink(parent) then
  //         true
  //       else
  //         ContainsSymlink(parent)
  //   }

  // function GetParentPath(p: string): string
  //   requires p != "" && p != "/"
  // {
  //   var idx := p.LastIndexOf("/");
  //   if idx <= 0 then
  //     "/"
  //   else
  //     p[..idx]
  // }

  predicate is_canonical_path(p: string)
  ensures true
  {
    true
    // if p == "" || p == "/" then
    //   true
    // else
    //   var parent := GetParentPath(p);
    //   if p.EndsWith("/") then
    //     is_canonical_path(parent)
    //   else
    //     is_canonical_path(parent) && !IsSymlink(p)
  }


// method ContainsConsecutiveDotLemma(s: seq<char>)
// requires |s| > 0
// requires exists i :: 0 <= i < |s| - 1 && is_dot(s[i]) && is_dot(s[i + 1]) ==> s[i] == s[i + 1]
// {
// }

//  predicate hasPathPermission(path: path, user: User, perm: Permission)
//  ensures hasPathPermission(path, user, perm) <==> path in permissions.Keys && user in permissions[path].Keys && perm in permissions[path][user]
//   {
//     && path in permissions.Keys
//     && user in permissions[path].Keys
//     && perm in permissions[path][user]
//   }

// predicate has_traversal_pattern(p: path, i: int)
// requires 0 <= i < |p|
// {
//     (i + 2 < |p| && p[i] == '.' && p[i+1] == '.' && (p[i+2] == '/' || p[i+2] == '\\')) ||
//     (i + 5 < |p| && p[i..i+6] == ['%', '2', 'e', '%', '2', 'e']) ||
//     (i + 8 < |p| && p[i..i+9] == ['%', '2', '5', '2', 'e', '%', '2', '5', '2', 'e']) ||
//     (i > 0 && p[i-1] == '/' && i + 2 < |p| && p[i] == '.' && p[i+1] == '.' && p[i+2] == '.')
// }


// function decode_percent(s: seq<char>, i: int): (char, int)
//     requires i + 2 < |s|
//     requires forall j:: i+2 < j < |s| ==> s[j] == '%'
// {
//     var hex := s[i+1..i+3];
//     if hex == "2e" || hex == "2E" then
//         ('.', i + 3)
//     else
//         (s[i], i + 1)
// }


// predicate has_path_traversal(p: path)
// ensures exists i :: 0 <= i < |p| ==> has_traversal_pattern(p, i)
// {
//     exists i :: 0 <= i < |p| && has_traversal_pattern(p, i)
// }




// predicate validate_file(f: file)
// requires 0 <= |f| <= fileMaxLength
// ensures forall i :: 0 <= i < |f|  ==> is_file_valid_char(f[i])
//          && alpha_numeric(f[0]) && alpha_numeric(f[|f| - 1])
// {
//   forall i :: 0 <= i < |f| ==> is_file_valid_char(f[i]) && alpha_numeric(f[0]) && alpha_numeric(f[|f| - 1])

// }


// function is_separator(c: char): bool
// {
//     c == '/' || c == '\\'
// }

// function is_dot(c: char): bool
// {
//     c == '.' || c == '%' // '%' could be the start of an encoded dot
// }




// predicate is_dot_dot(p: path, i: int)
//     requires 0 <= i < |p|
// {
//     i + 1 < |p| && p[i] == '.' && p[i+1] == '.'
// }

// predicate is_percent_encoded_dot_dot(p: path, i: int)
//     requires 0 <= i < |p|
// {
//     (i + 5 < |p| && p[i..i+6] == ['%', '2', 'e', '%', '2', 'e']) ||
//     (i + 11 < |p| && p[i..i+12] == ['%', '2', '5', '2', 'e', '%', '2', '5', '2', 'e'])
// }

// predicate has_traversal_pattern(p: path, i: int)
//     requires 0 <= i < |p|
// {
//     (is_dot_dot(p, i) && (i == 0 || is_separator(p[i-1])) && (i + 2 == |p| || is_separator(p[i+2]))) ||
//     (is_percent_encoded_dot_dot(p, i) && (i == 0 || is_separator(p[i-1])) && (i + 6 == |p| || is_separator(p[i+6]))) ||
//     (i > 0 && is_separator(p[i-1]) && i + 2 < |p| && p[i] == '.' && p[i+1] == '.' && p[i+2] == '.')
// }

// function has_dot_dot(s: seq<char>): bool
// {
//     exists i :: 0 <= i < |s| - 1 && s[i] == '.' && s[i + 1] == '.' && (i + 2 == |s| || is_separator(s[i + 2]))
// }

