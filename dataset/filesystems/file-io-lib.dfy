include "/Users/pari/pcc-llms/dataset/filesystems/interface/interface-helper.dfy"
newtype{:nativeType "byte"} byte = i:int | 0 <= i < 0x100
newtype{:nativeType "int"} int32 = i:int | -0x80000000 <= i < 0x80000000
newtype{:nativeType "int"} nat32 = i:int | 0 <= i < 0x80000000
newtype{:nativeType "int"} maxPath = i:int | 0 <= i < 256
// datatype path = path(length: int, data: seq<char>) //datatype image = image(width: int, height: int, data: seq<byte>)
// datatype access = access(accessType: seq<char>)
type NonEmptySeq = x: seq<char> | |x| > 0 witness ['a']
// newtype{:nativeType "char"} validPathChar = c:char | c
// newtype{:nativeType "path"} path = c:char | 

//TODO: Should avoid data races (reading and writing data at the same time)

// class OkState
//   {
//   // constructor{:axiom} () requires false // unconstructible during real execution
//    constructor() {}
//   function{:axiom} ok():bool reads this // reads the state of okState and returns a boolean
// }
// class OkState {
//   var isOk: bool;

//   constructor() {
//     isOk := true;
//   }

//   method UpdateOk(newState: bool)
//     modifies this
//     ensures isOk == newState
//   {
//     isOk := newState;
//   }

//   predicate{:axiom} ok()
//     reads this
//   {
//     isOk
//   }
// }
// class HostEnvironment
//   {
//   var ok:OkState
//   // constructor{:axiom} () requires false // non-constructive
//   constructor() {
//     ok := new OkState();
//   }
//   // ghost var ok:OkState // only for specificaions and verifications with no run-time effect
//  }

class OkState
  {
  constructor{:extern} () requires false
  function{:extern} ok():bool reads this
}

class HostEnvironment
  {
  constructor{:extern} () requires false
  ghost var ok:OkState
}



class FileStream
  {
  var env:HostEnvironment
  function{:axiom} Name():string reads this
  function{:axiom} IsOpen():bool reads this
  constructor{:axiom} () requires false
  // function{:axiom} Access():string reads this
  // function {:axiom} Capabilities():(string, string) reads this
  // function{:axiom} Path():string reads this


  // static method{:axiom} Open(name:array<char>, ghost env:HostEnvironment, access:array<char>)
  static method{:axiom} Open(name: path, env:HostEnvironment)
    returns(ok:bool, f:FileStream)
    requires name[..] in nonSensitiveFilesList
    requires name[..] !in sensitivePaths
    requires validate_file(name)
    // filetype validation should be done here
    // requires access[..] in ["read", "write"]
    // requires capabilities in [("bar.txt", "write")]
    requires env.ok.ok()
    modifies env.ok
    ensures  env.ok.ok() == ok
    ensures  ok ==> fresh(f) && f.env == env && f.IsOpen() && f.Name() == name[..]
    ensures f.IsOpen() <==> validate_file(name)


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

  method{:axiom} Read(f: file, user: seq<char>, fileOffset:nat32, buffer:array<byte>, start:int32, end:int32) returns(ok:bool)
    requires env.ok.ok()
    requires IsOpen()
    requires 0 <= start as int <= end as int <= buffer.Length
    requires 0 < |f| <= fileMaxLength
    requires 0 < |f| - 4 <= 10 //checks file type exists 
    //ToDo: validation file type format is required .txt, .pdf, .docx
    requires contains_sequence(nonSensitiveFilesList, f)
    requires f !in sensitivePaths
    requires f[(|f| - 4)..] !in invalidFileTypes
    // requires Access() in ["read", "write"]
    // requires Capabilities() in [("bar.txt", ["read, write"]), ("baz.txt", ["read"])]
    modifies env.ok
    modifies buffer
    ensures  env == old(env)
    ensures  env.ok.ok() == ok
    ensures  Name() == old(Name())
    ensures  forall i:int :: 0 <= i < buffer.Length && !(start as int <= i < end as int) ==> buffer[i] == old(buffer[i])
    ensures  ok ==> IsOpen()

  method{:axiom} Write(f: file, fileOffset:nat32, buffer:array<byte>, start:int32, end:int32) returns(ok:bool)
  // method{:axiom} Write(fileOffset:nat32, buffer:seq<byte>, start:int32, end:int32) returns(ok:bool)
    requires env.ok.ok()
    requires IsOpen()
    requires 0 <= start as int <= end as int <= buffer.Length
    // requires 0 <= start as int <= end as int <= |buffer|
    requires f in nonSensitiveFilesList
    requires 0 < |f| <= fileMaxLength
    requires 0 < |f| - 4 <= 10 //checks file type exists 
    //ToDo: validation file type format is required .txt, .pdf, .docx
    requires contains_sequence(nonSensitiveFilesList, f)
    requires f !in sensitivePaths
    requires f[(|f| - 4)..] !in invalidFileTypes
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

  method{:axiom} Join(p: path, f: file) returns(ok:bool, result: path)
    requires 0 < |f| <= fileMaxLength
    requires 0 < |p| <= dirMaxLength - fileMaxLength
    requires contains_sequence(nonSensitiveFilesList, f)
    requires p !in sensitivePaths
    requires p in currWDir && validate_dir_name(p)
    requires f in nonSensitiveFilesList && Name() in nonSensitiveFilesList
    requires f[(|f| - 4)..] !in invalidFileTypes
    requires |p| > 0 // ToDo: Use a function for path validation
    requires env.ok.ok()
    requires has_absolute_path(p) && p[..] !in sensitivePaths
    requires IsOpen()
    modifies this
    modifies env.ok
    ensures  env != old(env)
    ensures  env.ok.ok() == ok
    ensures  Name() == old(Name())
    ensures result == path_join(p, f)
    ensures has_absolute_path(result) && result[..] !in sensitivePaths
    ensures  ok ==> path_join(p, f) == result && has_absolute_path(result) && result[..] !in sensitivePaths

  method{:axiom} GetCWD(currDir: path) returns (ok: bool)
  modifies this
  modifies env.ok
  requires env.ok.ok()
  requires currDir !in sensitivePaths
  requires currDir in currWDir
  ensures  env == old(env)
  ensures  env.ok.ok() == ok
  ensures  Name() == old(Name())

  method{:axiom} rmdir (p: path) returns (ok:bool)
    modifies this
    modifies env.ok
    requires env.ok.ok()
    requires p !in sensitivePaths
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