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

  
  static method{:axiom} SafeOpenAPI(name: seq<char>) returns(ok:bool, f:FileStream)
    requires NonEmptyString(name)
    requires !IsDangerousPath(name)
    requires HasAbsolutePath(name)
    requires IsValidPathName(name)
    ensures  ok ==> fresh(f) && f.IsOpen() && f.Name() == name[..]

  method{:axiom} SafeCloseAPI() returns(ok:bool)
    requires !ListContainsString(sensitivePaths, Name()) || Name() !in sensitivePaths
    requires IsOpen()
    modifies this
    ensures !IsOpen()
    requires env.ok.ok()
    modifies env.ok
    ensures  env == old(env)
    ensures  env.ok.ok() == ok

  method{:axiom} SafeReadAPI(p: path, fileOffset:nat32, buffer:array<byte>, start:int32, end:int32) returns(ok:bool)
      modifies this
      requires IsOpen()
      requires 0 <= start as int <= end as int <= buffer.Length
      requires NonEmptyString(p)
      requires IsValidFileExtension(p)
      modifies buffer
      ensures  Name() == old(Name())
      ensures ByteContentLengthIsValid(buffer)
      ensures  ok ==> IsOpen()

  method{:axiom} SafeWriteAPI(p: path, fileOffset:nat32, buffer:array<byte>, start:int32, end:int32) returns(ok:bool)
      requires IsOpen()
      requires 0 <= start as int32 <= end as int32
      requires !IsDangerousPath(p)
      requires HasValidPathLength(p)
      requires HasAbsolutePath(p)
      requires IsValidPathName(p)
      requires ByteContentLengthIsValid(buffer)
      requires IsValidFileExtension(p)
      modifies this
      ensures  Name() == old(Name())
      ensures  ok ==> IsOpen()

  method ValidFile(f: file) returns (ok:bool)
    requires NonEmptyString(f)
    requires !IsDangerousPath(f)
    requires !ContainsConsecutivePeriods(f)
    requires HasAbsolutePath(f)
    requires IsValidFileName(f)

  method{:axiom} Copy(dstFile: path, data: seq<char>) returns(ok:bool)
    requires IsOpen()
    requires 0 < |data| <= 0x7fffffff
    requires |dstFile| <= fileMaxLength
    requires dstFile !in sensitivePaths
    requires IsValidDir(dstFile)
    requires !ListContainsString(sensitivePaths, dstFile) || (dstFile !in sensitivePaths)
    requires dstFile !in sensitivePaths
    requires fileMinLength < |dstFile| <= fileMaxLength
    requires dstFile[(|dstFile| - 4)..] !in invalidFileTypes
    modifies this
    ensures  Name() == old(Name())
    ensures  ok ==> IsOpen() && validate_file_type(Name()) && dstFile !in sensitivePaths

  method{:axiom} SafeFlushAPI() returns(ok:bool)
    requires IsOpen()
    modifies this
    ensures  Name() == old(Name())
    ensures  ok ==> IsOpen()

  method SafeJoinAPI(p: path, f: file) returns(result: path)
    requires IsOpen()
    modifies this
    ensures  Name() == old(Name())
    requires NonEmptyString(f)
    requires NonEmptyString(p)
    requires !IsDangerousPath(f)
    requires HasAbsolutePath(f)
    requires IsValidFileName(f)
    requires IsValidPathName(p)
    requires 0 < GetPathLength(PathOrFile.Path(p))
    requires 0 < |p| < pathMaxLength && 0 < |f| < fileMaxLength && 0 < |p| + |f| < pathMaxLength
    requires JointPathSize(p, f)
    ensures result == PathJoin(p, f) || result == ""
    {
      if |p| + |f| >= pathMaxLength || |p| + |f| == 0 
      {
        result := "";
      }
      else
      {
        result := PathJoin(p, f);
      }
    
    }

    // requires 0 < |p| < pathMaxLength && 0 < |p| + |f| < pathMaxLength
    // requires p !in sensitivePaths
    // requires IsValidDir(p)
    // requires !ListContainsString(sensitivePaths, f) || (f !in sensitivePaths)
    // requires f[(|f| - 4)..] !in invalidFileTypes
    // requires HasAbsolutePath(p) && p[..] !in sensitivePaths
    // requires IsOpen()
    // modifies this
    // ensures  Name() == old(Name())
    // ensures result == path_join(p, f)
    // ensures HasAbsolutePath(result) && result[..] !in sensitivePaths
    // ensures  ok ==> path_join(p, f) == result && HasAbsolutePath(result) && result[..] !in sensitivePaths



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
    requires |dir| <= pathMaxLength  // The path must be valid
    requires dir !in sensitivePaths
    modifies this
    requires dir in fs.Keys  // The directory must exist
    requires IsValidDir(dir)  // The path must point to a directory
    requires isDirectory(dir)
    requires forall p | p in fs.Keys :: !isPrefix(dir, p) || p == dir  // The directory must be empty
    ensures old(dir in fs.Keys) && !success ==>
              fs == old(fs)  // If removal fails, the file system is unchanged
    ensures success ==>
              fs == map p | p in old(fs.Keys) && p != dir :: old(fs[p])  // If successful, dir is removed
    ensures old(dir in fs.Keys) ==> success  // If the directory existed, removal should succeed
    ensures  Name() == old(Name())

 method{:axiom} FileExists(p: path) returns (fileFound: bool)
    requires |p| <= pathMaxLength
    requires p !in sensitivePaths
    requires IsValidDir(p)
    requires IsOpen()
    ensures fileFound <==> p in fs.Keys
  {
    fileFound := p in fs.Keys;
  }

  // Helper method to check if a path exists and is a file
  method{:axiom} IsFile(p: path) returns (isFile: bool)
    requires |p| <= pathMaxLength
    requires p !in sensitivePaths
    requires IsValidDir(p)
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
    requires |p| <= pathMaxLength
    requires p !in sensitivePaths
    requires IsValidDir(p)
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
