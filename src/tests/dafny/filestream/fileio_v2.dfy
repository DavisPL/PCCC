newtype{:nativeType "byte"} byte = i:int | 0 <= i < 0x100
newtype{:nativeType "int"} int32 = i:int | -0x80000000 <= i < 0x80000000
newtype{:nativeType "int"} nat32 = i:int | 0 <= i < 0x80000000
newtype{:nativeType "int"} maxPath = i:int | 0 <= i < 256
datatype path = path(length: int, data: seq<char>) //datatype image = image(width: int, height: int, data: seq<byte>)
datatype access = access(accessType: seq<char>)
// newtype{:nativeType "char"} validPathChar = c:char | c
// newtype{:nativeType "path"} path = c:char | 
// TODO: Define a new datatype for path (os.path type is a string)
// TODO: Add constant values for CWD and everytime get.cwd is called it should check the value be the same
// ---------------   Constant values  ----------------
const sensitivePaths := ["/usr", "/System", "/bin", "/sbin", "/var", "/usr/local"]
const fileMaxLength := 255
const dirMaxLength := 4096
const currWDir := ["/Users/pari/pcc-llms/src/playground"]
const nonSensitiveFiles := ["safeFile_1.txt", "safeFile_2.txt", "safeFile_3.txt", "bar.txt", "baz.txt"]


class OkState
  {
  constructor{:axiom} () requires false // unconstructible during real execution
  function{:axiom} ok():bool reads this // reads the state of okState and returns a boolean
}

class HostEnvironment
  {
  constructor{:axiom} () requires false // non-constructive
  ghost var ok:OkState // only for specificaions and verifications with no run-time effect
 }



class FileStream
  {
  ghost var env:HostEnvironment
  function{:axiom} Name():string reads this
  function{:axiom} IsOpen():bool reads this
  constructor{:axiom} () requires false
  // function{:axiom} Access():string reads this
  // function {:axiom} Capabilities():(string, string) reads this
  // function{:axiom} Path():string reads this

  // function{:axiom} FileIsValid():bool reads this
  // function{:axiom} DirIsValid():bool reads this

  predicate{:axiom} IsValidCharacter(c: char)
      // Valid characters include letters, digits, underscores, hyphens, and periods
    {
      (c >= 'a' && c <= '~') || c == ' '
    }

  predicate{:axiom} HasAllowedCharacters(c: char)
  // Valid characters include letters, digits, underscores, hyphens, and periods
    {
      (c >= 'a' && c <= 'z') ||
      (c >= 'A' && c <= 'Z') ||
      (c >= '0' && c <= '9') ||
      c == '_' ||
      c == '-' ||
      c == '.'  
    }

  predicate IsValidDirName(dirName: seq<char>)
  {
      // Check if the directory name is not empty
      0 < |dirName| <= dirMaxLength && 
      // Check if each character in the directory name is a valid character
      forall i :: 0 <= i < |dirName| ==> HasAllowedCharacters(dirName[i])
  }

   predicate IsValidFileName(fileName: seq<char>) 
  {
      // Check if the filename is not empty 
      // Check if the filename length is within the specified range
      0 < |fileName| <= fileMaxLength &&
      // Check if the filename contains only allowed characters (e.g., letters, digits, underscores, hyphens, periods)
      forall c :: 0 <= c < |fileName| ==> (HasAllowedCharacters(fileName[c]) &&
      // Check if the filename does not start or end with a period (.)
      fileName[0] != '.' && fileName[|fileName| - 1] != '.' &&
      // Check if the filename is not one of the reserved names
      !(fileName in {"CON", "PRN", "AUX", "NUL", "COM1", "COM2", 
      "COM3", "COM4", "LPT1", "LPT2", "LPT3", "LPT4", "LPT5", "LPT6",
      "LPT7", "LPT8", "LPT9"}))
  }

  predicate hasPathTraversal(path: seq<char>)
  {
    forall i :: 0 <= i < |path| ==> (((i < |path| - 1 && ((path[i] == '.' && path[i + 1] == '.') 
    || (path[i] == '/' && path[i + 1] == '/'))) 
    || (i < |path| - 2 && path[i] == '.' && path[i + 1] == '.' && path[i + 2] == '/')))
  }

  // static method{:axiom} Open(name:array<char>, ghost env:HostEnvironment, access:array<char>)
    // static method{:axiom} Open(name:seq<char>, ghost env:HostEnvironment)
  static method{:axiom} Open(name:array<char>, ghost env:HostEnvironment)
    returns(ok:bool, f:FileStream)
    // CannotAccessSensitiveFiles(l: ["bar.txt", "baz.txt"], access: ["bar.txt", "baz.txt"])
    requires name[..] in nonSensitiveFiles
    // requires access[..] in ["read", "write"]
    // requires capabilities in [("bar.txt", "write")]
    requires env.ok.ok()
    modifies env.ok
    ensures  env.ok.ok() == ok
    ensures  ok ==> fresh(f) && f.env == env && f.IsOpen() && f.Name() == name[..]

  // predicate isSubstring(p: path)
  // ensures forall i | i in sensitivePaths :: 0 < i < path.length
  // ensures exists substring :: substring in sensitivePaths && exists i :: 0 < i < (path.length - i) && forall j :: 0 <= j < |i| ==> 
  // {
  //   forall d | d in sensitivePaths :: d 
  // }
  // A function that checks if any input path is valid
  // function{:axiom} validatePath(p:path, ghost env:HostEnvironment): bool
  //   requires p.data[..] !in sensitivePaths
  //   requires < |p.data|

  method{:axiom} Close() returns(ok:bool)
    requires Name() in nonSensitiveFiles
    // requires Access() in ["read", "write"]
    // requires Capabilities in [("bar.txt", ["read, write"]), ("baz.txt", ["read"])]
    requires env.ok.ok()
    requires IsOpen()
    modifies this
    modifies env.ok
    ensures  env == old(env)
    ensures  env.ok.ok() == ok

  method{:axiom} Read(fileOffset:nat32, buffer:array<byte>, start:int32, end:int32) returns(ok:bool)
  // method{:axiom} Read(fileOffset:nat32, buffer:seq<char>, start:int32, end:int32) returns(ok:bool)
    requires env.ok.ok()
    requires IsOpen()
    requires 0 <= start as int <= end as int <= buffer.Length
    requires Name() in nonSensitiveFiles
    // requires Access() in ["read", "write"]
    // requires Capabilities() in [("bar.txt", ["read, write"]), ("baz.txt", ["read"])]
    modifies env.ok
    modifies buffer
    ensures  env == old(env)
    ensures  env.ok.ok() == ok
    ensures  Name() == old(Name())
    ensures  forall i:int :: 0 <= i < buffer.Length && !(start as int <= i < end as int) ==> buffer[i] == old(buffer[i])
    ensures  ok ==> IsOpen()

  method{:axiom} Write(fileOffset:nat32, buffer:array<byte>, start:int32, end:int32) returns(ok:bool)
  // method{:axiom} Write(fileOffset:nat32, buffer:seq<byte>, start:int32, end:int32) returns(ok:bool)
    requires env.ok.ok()
    requires IsOpen()
    requires 0 <= start as int <= end as int <= buffer.Length
    // requires 0 <= start as int <= end as int <= |buffer|
    requires Name() in nonSensitiveFiles
    // requires forall i :: 0 <= i < path.Length ==> (((i < path.Length - 1 && ((path[i] == '.' && path[i + 1] == '.') 
    // || (path[i] == '/' && path[i + 1] == '/'))) 
    // || (i < path.Length - 2 && path[i] == '.' && path[i + 1] == '.' && path[i + 2] == '/')))
    // requires Access() in ["read", "write"]
    // requires Capabilities in [("bar.txt", ["read, write"]), ("baz.txt", ["read"])]
    modifies this
    modifies env.ok
    ensures  env == old(env)
    ensures  env.ok.ok() == ok
    ensures  Name() == old(Name())
    ensures  ok ==> IsOpen()

  method{:axiom} Flush() returns(ok:bool)
    requires env.ok.ok()
    requires IsOpen()
    modifies this
    modifies env.ok
    ensures  env == old(env)
    ensures  env.ok.ok() == ok
    ensures  Name() == old(Name())
    ensures  ok ==> IsOpen()



method{:axiom} Join(path:seq<char>, file:seq<char>) returns(ok:bool, result:seq<char>)
  //predicate for IsFileValid
  //predicate for IsPathValid
  //predicate for IsPathSensitive --> can swap with different implementations
  requires path[..] in currWDir
  requires path !in sensitivePaths
  requires file[..] in nonSensitiveFiles
  requires IsValidFileName(file)
  requires env.ok.ok()
  requires !hasPathTraversal(path)
  requires !hasPathTraversal(file)
  requires IsOpen()
  modifies this
  modifies env.ok
  ensures  env == old(env)
  ensures  env.ok.ok() == ok
  // assume !hasPathTraversal(result)
  // ensures !hasPathTraversal(result)
  ensures |result| <= |path| + |file|
  ensures  ok ==> IsOpen()

  // method{:axiom} IsFilenameValid(filename: seq<char>) returns (ok: bool)
  // requires env.ok.ok()
  // requires IsOpen()
  // requires forall i :: 0 <= i < |filename| ==> ((filename[i] >= 'a' && filename[i] <= 'z') ||
  //  (filename[i] >= 'A' && filename[i] <= 'Z') || (filename[i] >= '0' && filename[i] <= '9') ||
  //   filename[i] == '_' || filename[i] == '.' || filename[i] == '-')
  // modifies this
  // modifies env.ok
  // ensures  env == old(env)
  // ensures  env.ok.ok() == ok
  // ensures  Name() == old(Name())
  // ensures  ok ==> IsOpen()

  // method{:axiom} GetCWD(dirname: seq<char>) returns (ok: bool)
  // requires env.ok.ok()
  // requires IsOpen()
  // ensures dirname == old(dirname)
  // ensures  env == old(env)
  // ensures  env.ok.ok() == ok
  // ensures  Name() == old(Name())
  // ensures  ok ==> IsOpen()

  method{:axiom} GetCWD(currDir: seq<char>) returns (ok: bool)
  modifies this
  modifies env.ok
  requires env.ok.ok()
  requires currDir !in sensitivePaths
  requires currDir in currWDir
  ensures  env == old(env)
  ensures  env.ok.ok() == ok
  ensures  Name() == old(Name())
  ensures  ok ==> IsOpen()

method{:axiom} rmdir (dirname: seq<char>) returns (ok:bool)
  modifies this
  modifies env.ok
  requires env.ok.ok()
  requires dirname !in sensitivePaths


// method StringDoesNotContainDots(path: seq<char>) returns (isValid: bool)
//   ensures forall i :: 0 <= i < |path| ==> (((i < |path| - 1 && ((path[i] == '.' && path[i + 1] == '.') 
//     || (path[i] == '/' && path[i + 1] == '/'))) 
//     || (i < |path| - 2 && path[i] == '.' && path[i + 1] == '.' && path[i + 2] == '/')))
// {
//     isValid := true; // Assume string is valid unless we find ".." or "../"

//     // Check for ".." and "../"
//     var i := 0;
//     while i < |path| - 1 // No need to check the last character alone
//     invariant 0 <= i <= |path|
//     {
//         // Check for ".."
//         if i < |path| - 1 && path[i] == '.' && path[i + 1] == '.'
//         {
//             isValid := false;
//         }

//         // Check for "../"
//         if i < |path| - 2 && path[i] == '.' && path[i + 1] == '.' && path[i + 2] == '/'
//         {
//             isValid := false;
//         }

//         if path[i] == '/' && path[i + 1] == '/' // Check for "//"
//         {
//             isValid := false;
//         }

//         if !isValid { break; } // Early exit if invalid pattern is found
//         i := i + 1;
//     }
}


// TODO: How to link axioms to python functions
// TODO: Basically Join is similar to concatenation of two string
  // method concatenation(str1: seq<char>, str2: seq<char>) returns (ok: bool, result: seq<char>) 
  // requires env.ok.ok()
  // modifies this
  // modifies env.ok
  // ensures  env == old(env)
  // ensures  env.ok.ok() == ok

