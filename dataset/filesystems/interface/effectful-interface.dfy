include "/Users/pari/pcc-llms/dataset/filesystems/interface/interface-helper.dfy"
newtype{:nativeType "byte"} byte = i:int | 0 <= i < 0x100
newtype{:nativeType "int"} int32 = i:int | -0x80000000 <= i < 0x80000000
newtype{:nativeType "int"} nat32 = i:int | 0 <= i < 0x80000000
newtype{:nativeType "int"} maxPath = i:int | 0 <= i < 256
// datatype path = path(length: int, data: seq<char>) //datatype image = image(width: int, height: int, data: seq<byte>)
// datatype access = access(accessType: seq<char>)
type NonEmptySeq = x: seq<char> | |x| > 0 witness ['a']
// Define a type for file system entries
datatype FSEntry = File(content: seq<byte>) | Directory(entries: map<string, FSEntry>)

// newtype{:nativeType "char"} validPathChar = c:char | c
// newtype{:nativeType "path"} path = c:char | 

//TODO: Avoid data races (reading and writing data at the same time)

// class ReadWriteLock {
//   var readers: nat
//   var writer: bool

//   constructor()
//     ensures readers == 0 && !writer
//   {
//     readers := 0;
//     writer := false;
//   }

//   method acquireRead()
//     modifies this
//     ensures old(readers) < readers
//     ensures !writer
//   {
//     assume !writer;
//     readers := readers + 1;
//   }

//   method releaseRead()
//     modifies this
//     requires readers > 0
//     ensures readers == old(readers) - 1
//   {
//     readers := readers - 1;
//   }

//   method acquireWrite()
//     modifies this
//     ensures writer
//     ensures readers == 0
//   {

//     assume readers == 0 && !writer;
//     writer := true;
//   }

//   method releaseWrite()
//     modifies this
//     requires writer
//     ensures !writer
//   {
//     writer := false;
//   }
// }

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
  // The file system is a map from paths to FSEntries
  var fs: map<path, FSEntry>
  // var locks: map<path, ReadWriteLock>
  var currentDirectory: path
  function{:axiom} Name():string reads this
  function{:axiom} IsOpen():bool reads this
  constructor{:axiom} () requires false

  // Helper predicate to check if a path is a directory
  predicate isDirectory(p: path)
    reads this
  {
    p in fs.Keys && fs[p].Directory?
  }

  // Helper function to get the contents of a directory
  function getDirectoryContents(p: path): map<string, FSEntry>
    requires isDirectory(p)
    reads this
  {
    match fs[p] {
      case Directory(entries) => entries
      case File(_) => map[] // This case should never occur due to the requires clause
    }
  }


  // static method{:axiom} Open(name:array<char>, ghost env:HostEnvironment, access:array<char>)
  static method{:axiom} Open(name: path)
    returns(ok:bool, f:FileStream)
    requires name[..] in nonSensitiveFilesList
    requires name[..] !in sensitivePaths
    requires validate_file(name)
    ensures  ok ==> fresh(f) && f.IsOpen() && f.Name() == name[..]
    ensures f.IsOpen() <==> validate_file(name)


  method{:axiom} Close() returns(ok:bool)
    requires Name() in nonSensitiveFilesList
    // requires Access() in ["read", "write"]
    // requires Capabilities in [("bar.txt", ["read, write"]), ("baz.txt", ["read"])]
    requires env.ok.ok()
    requires IsOpen()
    modifies this

  method{:axiom} Read(f: file, fileOffset:nat32, buffer:array<byte>, start:int32, end:int32) returns(ok:bool)
    // modifies this`locks
    modifies this
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
    modifies buffer
    ensures  Name() == old(Name())
    ensures  forall i:int :: 0 <= i < buffer.Length && !(start as int <= i < end as int) ==> buffer[i] == old(buffer[i])
    ensures  ok ==> IsOpen()
    ensures ok <==> validate_file_type(f)

   
  method{:axiom} Write(f: file, fileOffset:nat32, buffer:array<byte>, start:int32, end:int32) returns(ok:bool)
  // method{:axiom} Write(fileOffset:nat32, buffer:seq<byte>, start:int32, end:int32) returns(ok:bool)
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
    ensures  Name() == old(Name())
    ensures  ok ==> IsOpen()

  method{:axiom} Flush() returns(ok:bool)
    requires IsOpen()
    modifies this
    ensures  Name() == old(Name())
    ensures  ok ==> IsOpen()

  method{:axiom} Join(p: path, f: file) returns(ok:bool, result: path)
    requires 0 < |f| <= fileMaxLength
    requires 0 < |p| <= dirMaxLength - fileMaxLength - 1
    requires contains_sequence(nonSensitiveFilesList, f)
    requires p !in sensitivePaths
    requires validate_dir_name(p)
    requires f in nonSensitiveFilesList && Name() in nonSensitiveFilesList
    requires f[(|f| - 4)..] !in invalidFileTypes
    requires |p| > 0 // ToDo: Use a function for path validation
    requires has_absolute_path(p) && p[..] !in sensitivePaths
    requires IsOpen()
    modifies this
    ensures  Name() == old(Name())
    ensures result == path_join(p, f)
    ensures has_absolute_path(result) && result[..] !in sensitivePaths
    ensures  ok ==> path_join(p, f) == result && has_absolute_path(result) && result[..] !in sensitivePaths

  method{:axiom} GetCurrentDirectory() returns (cwd: path)
    // Method to get the current working directory
    modifies this
    ensures cwd !in sensitivePaths
    ensures cwd == currentDirectory
    ensures cwd in fs.Keys && fs[cwd].Directory?
  

  method{:axiom} remove (dir: path) returns (success: bool)
    requires |dir| <= dirMaxLength  // The path must be valid
    requires dir !in sensitivePaths
    modifies this
    requires dir in fs.Keys  // The directory must exist
    requires validate_dir_name(dir)  // The path must point to a directory
    requires isDirectory(dir)
    requires forall p | p in fs.Keys :: !isPrefix(dir, p) || p == dir  // The directory must be empty
    modifies this
    ensures old(dir in fs.Keys) && !success ==>
              fs == old(fs)  // If removal fails, the file system is unchanged
    ensures success ==>
              fs == map p | p in old(fs.Keys) && p != dir :: old(fs[p])  // If successful, dir is removed
    ensures old(dir in fs.Keys) ==> success  // If the directory existed, removal should succeed
    ensures  Name() == old(Name())

  //     // Method to change the current working directory
  // method changeDirectory(newDir: path) returns (success: bool)
  //   requires newDir in fs.Keys
  //   modifies this
  //   ensures success ==> currentDirectory == newDir && fs[newDir].Directory?
  //   ensures !success ==> currentDirectory == old(currentDirectory)
  // {
  //   if newDir in fs.Keys && fs[newDir].Directory? {
  //     currentDirectory := newDir;
  //     success := true;
  //   } else {
  //     success := false;
  //   }
  // }


// TODO: How to link axioms to python functions

}