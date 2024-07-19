include "/Users/pari/pcc-llms/dataset/filesystems/files-helper.dfy"
newtype{:nativeType "byte"} byte = i:int | 0 <= i < 0x100
newtype{:nativeType "int"} int32 = i:int | -0x80000000 <= i < 0x80000000
newtype{:nativeType "int"} nat32 = i:int | 0 <= i < 0x80000000
newtype{:nativeType "int"} maxPath = i:int | 0 <= i < 256
datatype path = path(length: int, data: seq<char>) //datatype image = image(width: int, height: int, data: seq<byte>)
datatype access = access(accessType: seq<char>)
type NonEmptySeq = x: seq<char> | |x| > 0 witness ['a']
// newtype{:nativeType "char"} validPathChar = c:char | c
// newtype{:nativeType "path"} path = c:char | 

//TODO: Should avoid data races (reading and writing data at the same time)

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


  predicate hasPathTraversal(path: seq<char>)
  {
    forall i :: 0 <= i < |path| ==> (((i < |path| - 1 && ((path[i] == '.' && path[i + 1] == '.') 
    || (path[i] == '/' && path[i + 1] == '/'))) 
    || (i < |path| - 2 && path[i] == '.' && path[i + 1] == '.' && path[i + 2] == '/')))
  }


  // static method{:axiom} Open(name:array<char>, ghost env:HostEnvironment, access:array<char>)
    // static method{:axiom} Open(name:seq<char>, ghost env:HostEnvironment)
  static method{:axiom} Open(name:seq<char>, ghost env:HostEnvironment)
    returns(ok:bool, f:FileStream)
    requires name[..] in nonSensitiveFilesList
    requires name[..] !in sensitivePaths
    requires forall i :: 0 <= i < |name| ==> validate_file_char(name[i])
    // filetype validation should be done here
    // requires access[..] in ["read", "write"]
    // requires capabilities in [("bar.txt", "write")]
    requires env.ok.ok()
    modifies env.ok
    ensures  env.ok.ok() == ok
    ensures  ok ==> fresh(f) && f.env == env && f.IsOpen() && f.Name() == name[..]
    ensures forall i :: 0 <= i < |name| ==> validate_file_char(name[i]) && alpha_numeric(name[0]) && alpha_numeric(name[|name| - 1])

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
    requires Name() in nonSensitiveFilesList
    // requires Access() in ["read", "write"]
    // requires Capabilities in [("bar.txt", ["read, write"]), ("baz.txt", ["read"])]
    requires env.ok.ok()
    requires IsOpen()
    modifies this
    modifies env.ok
    ensures  env == old(env)
    ensures  env.ok.ok() == ok

  method{:axiom} Read(fileOffset:nat32, buffer:array<byte>, start:int32, end:int32) returns(ok:bool)
    requires env.ok.ok()
    requires IsOpen()
    requires 0 <= start as int <= end as int <= buffer.Length
    requires Name() in nonSensitiveFilesList
    requires Name() in nonSensitiveFilesList
    requires Name() !in sensitivePaths
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
    requires Name() in nonSensitiveFilesList
    requires Name() in nonSensitiveFilesList
    requires Name() !in sensitivePaths
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


  method{:axiom} IsValidDirectoryName(dirName: seq<char>) // should not be axioms
    // Check if the directory name is not empty
    requires 0 < |dirName| <= dirMaxLength 
    // Check if each character in the directory name is a valid character
    ensures forall i :: 0 <= i < |dirName| ==> validate_file_char(dirName[i])  
    

  method{:axiom} Join(path:seq<char>, file:seq<char>) returns(ok:bool, result:seq<char>)
    requires path[..] in currWDir
    requires path !in sensitivePaths
    requires file[..] in nonSensitiveFilesList 
    requires env.ok.ok()
    // requires !hasPathTraversal(path)
    // requires !hasPathTraversal(file)
    requires IsOpen()
    modifies this
    modifies env.ok
    ensures  env == old(env)
    ensures  env.ok.ok() == ok
    ensures !hasPathTraversal(result)
    ensures |result| <= |path| + |file|
    ensures  ok ==> IsOpen()

  method{:axiom} GetCWD(currDir: seq<char>) returns (ok: bool)
  modifies this
  modifies env.ok
  requires env.ok.ok()
  requires currDir !in sensitivePaths
  requires currDir in currWDir
  ensures  env == old(env)
  ensures  env.ok.ok() == ok
  ensures  Name() == old(Name())

  method{:axiom} rmdir (dirname: seq<char>) returns (ok:bool)
    modifies this
    modifies env.ok
    requires env.ok.ok()
    requires dirname !in sensitivePaths
    ensures  env == old(env)
    ensures  env.ok.ok() == ok
    ensures  Name() == old(Name())


// TODO: How to link axioms to python functions
// TODO: Basically Join is similar to concatenation of two string
  // method concatenation(str1: seq<char>, str2: seq<char>) returns (ok: bool, result: seq<char>) 
  // requires env.ok.ok()
  // modifies this
  // modifies env.ok
  // ensures  env == old(env)
  // ensures  env.ok.ok() == ok

}