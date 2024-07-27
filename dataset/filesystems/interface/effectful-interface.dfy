include "/Users/pari/pcc-llms/dataset/filesystems/interface/interface-helper.dfy"
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

  
  static method{:axiom} Open(name: seq<char>)
    returns(ok:bool, f:FileStream)
    requires  IsNonEmpty(name)
    requires !IsDangerousPath(name)
    requires !ContainsConsecutivePeriods(name)
    requires HasAbsolutePath(name)
    requires is_valid_file(name)
    ensures  ok ==> fresh(f) && f.IsOpen() && f.Name() == name[..]

  static method{:axiom} OpenPath(p: path)
    returns(ok:bool, f:FileStream)
    requires |p| <= dirMaxLength
    requires p[..] !in sensitivePaths
    requires validate_dir_name(p)
    ensures  ok ==> fresh(f) && f.IsOpen() && f.Name() == p[..]
    ensures f.IsOpen() <==> validate_dir_name(p)

  method{:axiom} NonSensitiveFile() returns (ok:bool)
    requires !ListContainsString(sensitivePaths, Name()) || Name() !in sensitivePaths
    requires IsOpen()
    ensures ok ==> IsOpen()

  method{:axiom} Close() returns(ok:bool)
    requires !ListContainsString(sensitivePaths, Name()) || Name() !in sensitivePaths
    requires IsOpen()
    modifies this
    ensures !IsOpen()

  method{:axiom} ValidFileType() returns (ok:bool)
    requires fileMinLength < |Name()| <= fileMaxLength
    requires Name()[(|Name()| - 3)..]  !in invalidFileTypes && Name()[(|Name()| - 4)..]  !in invalidFileTypes
    requires IsOpen()
    ensures ok ==> IsOpen()

  method{:axiom} FileWithReadType() returns (ok:bool)
    requires fileMinLength < |Name()| <= fileMaxLength
    requires Name()[(|Name()| - 3)..] == "txt" || Name()[(|Name()| - 4)..] == "pdf" || Name()[(|Name()| - 4)..] == "docx"
    requires IsOpen()
    ensures ok ==> IsOpen()

  method{:axiom} FileWithWriteType() returns (ok:bool)
  requires fileMinLength < |Name()| <= fileMaxLength
  requires Name()[(|Name()| - 3)..] == "txt" || Name()[(|Name()| - 4)..] == "docx"
  requires IsOpen()
  ensures ok ==> IsOpen()

  method{:axiom} EmptyFile() returns (ok:bool)
    requires fileMinLength < |Name()| <= fileMaxLength
    requires IsOpen()
    ensures ok ==> IsOpen()

  method{:axiom} Read(f: file, fileOffset:nat32, buffer:array<byte>, start:int32, end:int32) returns(ok:bool)
      // modifies this`locks
      modifies this
      requires IsOpen()
      requires 0 <= start as int <= end as int <= buffer.Length
      requires fileMinLength < |f| <= fileMaxLength
      // requires 0 < |f| - 4 <= 10 //checks file type exists 
      //ToDo: validation file type format is required .txt, .pdf, .docx
      requires !ListContainsString(sensitivePaths, f)
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
      requires f !in sensitivePaths || !ListContainsString(sensitivePaths, f)
      requires fileMinLength < |f| <= fileMaxLength
      //ToDo: validation file type format is required .txt, .pdf, .docx
      requires f[(|f| - 4)..] !in invalidFileTypes
      // requires Access() in ["read", "write"]
      // requires Capabilities in [("bar.txt", ["read, write"]), ("baz.txt", ["read"])]
      modifies this
      ensures  Name() == old(Name())
      ensures  ok ==> IsOpen()

  method ValidFile(f: file) returns (ok:bool)
    requires  IsNonEmpty(f)
    requires !IsDangerousPath(f)
    requires !ContainsConsecutivePeriods(f)
    requires HasAbsolutePath(f)
    requires is_valid_file(f)

  method{:axiom} Copy(dstFile: path, data: seq<char>) returns(ok:bool)
    requires IsOpen()
    requires 0 < |data| <= 0x7fffffff
    requires |dstFile| <= fileMaxLength
    requires dstFile !in sensitivePaths
    requires validate_dir_name(dstFile)
    requires !ListContainsString(sensitivePaths, dstFile) || (dstFile !in sensitivePaths)
    requires dstFile !in sensitivePaths
    requires fileMinLength < |dstFile| <= fileMaxLength
    requires dstFile[(|dstFile| - 4)..] !in invalidFileTypes
    modifies this
    ensures  Name() == old(Name())
    ensures  ok ==> IsOpen() && validate_file_type(Name()) && dstFile !in sensitivePaths

  method{:axiom} Flush() returns(ok:bool)
    requires IsOpen()
    modifies this
    ensures  Name() == old(Name())
    ensures  ok ==> IsOpen()

  method{:axiom} Join(p: path, f: file) returns(ok:bool)
    requires IsOpen()
    modifies this
    ensures  Name() == old(Name())
    requires  IsNonEmpty(f)
    requires !IsDangerousPath(f)
    requires !ContainsConsecutivePeriods(f)
    requires !ContainsConsecutivePeriods(f)
    requires HasAbsolutePath(f)
    requires is_valid_file(f)
    ensures  ok ==> IsOpen()
    // ensures  ok ==> path_join(p, f) == p + f

    // requires 0 < |p| < dirMaxLength && 0 < |p| + |f| < dirMaxLength
    // requires p !in sensitivePaths
    // requires validate_dir_name(p)
    // requires !ListContainsString(sensitivePaths, f) || (f !in sensitivePaths)
    // requires f[(|f| - 4)..] !in invalidFileTypes
    // requires HasAbsolutePath(p) && p[..] !in sensitivePaths
    // requires IsOpen()
    // modifies this
    // ensures  Name() == old(Name())
    // ensures result == path_join(p, f)
    // ensures HasAbsolutePath(result) && result[..] !in sensitivePaths
    // ensures  ok ==> path_join(p, f) == result && HasAbsolutePath(result) && result[..] !in sensitivePaths

  method ExpectAbsolutePath(p: path) returns (ok:bool)
    // ensures HasAbsolutePath(p)
    ensures ok <==> HasAbsolutePath(p)
    {
      ok := HasAbsolutePath(p);
    }

  method IsEmptyPath(p: path) returns (ok:bool)
    requires 0 < |p| <= dirMaxLength
    ensures ok <==> |p| == 1
    {
      ok := |p| == 1;
    }

  method{:axiom} NoPathTraversal(p: path) returns (ok:bool)
    requires 0 < |p| <= dirMaxLength
    requires p[..] !in sensitivePaths
    requires validate_dir_name(p)
    requires IsOpen()
    ensures !ContainsConsecutivePeriods(p)
    ensures ok ==> IsOpen()

  method{:axiom} GetFileLength() returns (ok:bool, length:int32)
    requires IsOpen()
    ensures ok ==> length >= 0
    ensures !ok ==> length == -1

  method{:axiom} GetCurrentDirectory() returns (cwd: path)
    // Method to get the current working directory
    modifies this
    ensures cwd !in sensitivePaths
    ensures cwd == currentDirectory
    ensures cwd in fs.Keys && fs[cwd].Directory?
  

  method{:axiom} removeDir (dir: path) returns (success: bool)
    requires |dir| <= dirMaxLength  // The path must be valid
    requires dir !in sensitivePaths
    modifies this
    requires dir in fs.Keys  // The directory must exist
    requires validate_dir_name(dir)  // The path must point to a directory
    requires isDirectory(dir)
    requires forall p | p in fs.Keys :: !isPrefix(dir, p) || p == dir  // The directory must be empty
    ensures old(dir in fs.Keys) && !success ==>
              fs == old(fs)  // If removal fails, the file system is unchanged
    ensures success ==>
              fs == map p | p in old(fs.Keys) && p != dir :: old(fs[p])  // If successful, dir is removed
    ensures old(dir in fs.Keys) ==> success  // If the directory existed, removal should succeed
    ensures  Name() == old(Name())

 method{:axiom} FileExists(p: path) returns (fileFound: bool)
    requires |p| <= dirMaxLength
    requires p !in sensitivePaths
    requires validate_dir_name(p)
    requires IsOpen()
    ensures fileFound <==> p in fs.Keys
  {
    fileFound := p in fs.Keys;
  }

  // Helper method to check if a path exists and is a file
  method{:axiom} IsFile(p: path) returns (isFile: bool)
    requires |p| <= dirMaxLength
    requires p !in sensitivePaths
    requires validate_dir_name(p)
    requires IsOpen()
    ensures isFile ==> p in fs.Keys && fs[p].File?
    ensures !isFile ==> p !in fs.Keys || fs[p].Directory?
  {
    if p in fs.Keys && fs[p].File? {
      isFile := true;
    } else {
      isFile := false;
    }
  }

  method fileExists(p: path) returns (fileFound: bool)
    requires |p| <= dirMaxLength
    requires p !in sensitivePaths
    requires validate_dir_name(p)
    requires IsOpen()
    ensures fileFound <==> p in fs.Keys
  {
    fileFound := p in fs.Keys;
  }

  method{:axiom} GetFileSize() returns(ok:bool, size:int32)
      requires IsOpen()
      ensures ok ==> size >= 0
      ensures !ok ==> size == -1

  method{:axiom} SetPosition(position:nat64) returns (ok:bool)
    requires IsOpen()
    modifies this
    ensures Name() == old(Name())
    ensures ok ==> IsOpen()

  method{:axiom} ReadLine() returns (line:array<char>, ok:bool)
    requires IsOpen()
    modifies this
    ensures Name() == old(Name())
    ensures ok ==> IsOpen()
    ensures ok ==> fresh(line)

  method{:axiom} Append(buffer:array<byte>, start:int32, end:int32) returns (ok:bool)
    requires IsOpen()
    requires 0 <= start as int <= end as int <= buffer.Length
    modifies this
    ensures Name() == old(Name())
    ensures ok ==> IsOpen()

    method{:axiom} Seek(offset:nat64, whence:nat32) returns (ok:bool)
    // Moves the file pointer to a new position
    requires IsOpen()
    requires whence == 0 || whence == 1 || whence == 2  // 0: start, 1: current, 2: end
    modifies this
    ensures Name() == old(Name())
    ensures ok ==> IsOpen()


  method{:axiom} ReadAll() returns (data:array<byte>, ok:bool)
    requires IsOpen()
    modifies this
    ensures Name() == old(Name())
    ensures ok ==> IsOpen()
    ensures ok ==> fresh(data)
// TODO: How to link axioms to python functions

}
