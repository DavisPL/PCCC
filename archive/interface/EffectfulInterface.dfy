include "../Interface/Helper.dfy"
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
  ghost var env:HostEnvironment
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

  static method{:axiom} Open(name: seq<char>) returns(ok:bool, f:FileStream)
    requires non_empty_string(name)
    requires !has_dangerous_pattern(name)
    requires has_absolute_path(name)
    requires is_valid_path_name(name)
    ensures  ok ==> fresh(f) && f.IsOpen() && f.Name() == name[..]

  method{:axiom} Close() returns(ok:bool)
    requires !list_contains_string(sensitivePaths, Name()) || Name() !in sensitivePaths
    requires IsOpen()
    modifies this
    ensures !IsOpen()
    
  method{:axiom} Read(p: path, fileOffset:nat32, buffer:array<byte>, start:int32, end:int32) returns(ok:bool)
      requires non_empty_string(p)
      requires !has_dangerous_pattern(p)
      requires has_valid_path_length(p)
      requires has_absolute_path(p)
      requires is_valid_file_extension(p)
      requires has_valid_content_length(buffer)     
      requires IsOpen()
      requires 0 <= start as int <= end as int <= buffer.Length
      modifies buffer
      modifies this
      ensures  Name() == old(Name())
      ensures  ok ==> IsOpen()

  method{:axiom} Write(p: path, fileOffset:nat32, buffer:array<byte>, start:int32, end:int32) returns(ok:bool)
      requires !has_dangerous_pattern(p)
      requires has_valid_path_length(p)
      requires has_absolute_path(p)
      requires is_valid_path_name(p)
      requires has_valid_content_length(buffer)
      requires is_valid_file_extension(p)
      requires 0 <= start as int32 <= end as int32
      requires IsOpen()
      modifies this
      ensures  Name() == old(Name())
      ensures  ok ==> IsOpen()

  method ValidFile(f: file) returns (ok:bool)
    requires non_empty_string(f)
    requires !has_dangerous_pattern(f)
    requires !contains_consecutive_periods(f)
    requires has_absolute_path(f)
    requires is_valid_file_name(f)

  method{:axiom} Copy(dstFile: path, data: seq<char>) returns(ok:bool)
    requires IsOpen()
    requires 0 < |data| <= 0x7fffffff
    requires |dstFile| <= fileMaxLength
    requires dstFile !in sensitivePaths
    requires is_valid_dir(dstFile)
    requires !list_contains_string(sensitivePaths, dstFile) || (dstFile !in sensitivePaths)
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


    // requires 0 < |p| < pathMaxLength && 0 < |p| + |f| < pathMaxLength
    // requires p !in sensitivePaths
    // requires is_valid_dir(p)
    // requires !list_contains_string(sensitivePaths, f) || (f !in sensitivePaths)
    // requires f[(|f| - 4)..] !in invalidFileTypes
    // requires has_absolute_path(p) && p[..] !in sensitivePaths
    // requires IsOpen()
    // modifies this
    // ensures  Name() == old(Name())
    // ensures result == path_join(p, f)
    // ensures has_absolute_path(result) && result[..] !in sensitivePaths
    // ensures  ok ==> path_join(p, f) == result && has_absolute_path(result) && result[..] !in sensitivePaths



  method{:axiom} GetCurrentDirectory(p: seq<char>) returns (cwd: path)
    // Method to get the current working directory
    requires !has_dangerous_pattern(p)
    requires has_valid_path_length(p)
    requires has_absolute_path(p)
    requires is_valid_path_name(p)
    ensures cwd !in sensitivePaths
    ensures cwd in fs.Keys && fs[cwd].Directory?
  

  method{:axiom} removeDir (dir: path) returns (success: bool)
    requires |dir| <= pathMaxLength  // The path must be valid
    requires dir !in sensitivePaths
    modifies this
    requires dir in fs.Keys  // The directory must exist
    requires is_valid_dir(dir)  // The path must point to a directory
    requires isDirectory(dir)
    requires forall p | p in fs.Keys :: !is_prefix(dir, p) || p == dir  // The directory must be empty
    ensures old(dir in fs.Keys) && !success ==>
              fs == old(fs)  // If removal fails, the file system is unchanged
    ensures success ==>
              fs == map p | p in old(fs.Keys) && p != dir :: old(fs[p])  // If successful, dir is removed
    ensures old(dir in fs.Keys) ==> success  // If the directory existed, removal should succeed
    ensures  Name() == old(Name())


  // Helper method to check if a path exists and is a file
  method{:axiom} IsFile(p: path) returns (isFile: bool)
    requires |p| <= pathMaxLength
    requires p !in sensitivePaths
    requires is_valid_dir(p)
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
    requires is_valid_dir(p)
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

  method{:axiom} WriteAll(data:array<byte>) returns (ok:bool)
    requires IsOpen()
    requires has_valid_content_length(data)
    modifies this
    ensures Name() == old(Name())
    ensures ok ==> IsOpen()

  method{:extern} IsSymlink(p: path) returns (isSymlink: bool)
    requires is_absolute_path(p)
    requires is_canonical_path(p) // srcLink -> dstLink
    ensures isSymlink ==> is_absolute_path(p) && is_canonical_path(p)
    ensures !isSymlink ==> !is_absolute_path(p) || !is_canonical_path(p)
    {
      isSymlink := is_absolute_path(p) && is_canonical_path(p);

    }
  }

  method Join(p: path, f: file) returns(fullPath: path)
    requires non_empty_string(f)
    requires non_empty_string(p)
    requires !has_dangerous_pattern(f)
    requires has_absolute_path(f)
    requires is_valid_file_name(f)
    requires is_valid_path_name(p)
    requires has_valid_file_length(f)
    requires has_valid_path_length(p)
    requires has_valid_path_length(p+f)
    ensures fullPath == if p == "" then f
                        else if p[|p|-1] == '/' then p + f
                        else p + "/" + f
    {
      
      if p == "" {
          fullPath := f;
      } else if p[|p|-1] == '/' {
          fullPath := p + f;
      } else {
          fullPath := p + "/" + f;
      }
    
    }


 method JoinPaths(paths: array<string>, separator: string) returns (fullPath: string)
    requires paths.Length > 2  // Check for non-null and non-empty array
    requires forall i :: 0 <= i < paths.Length ==> paths[i] != ""  // Check for non-empty strings
    requires separator != "" && |separator| >= 1  // Separator must be a single character
    requires |paths[0]| > 0  // First path must be non-empty
    // ensures forall i :: 0 <= i < paths.Length ==> (fullPath == fullPath + separator + paths[i]) ||  (fullPath == paths[0])// Ensures non-emptiness in the result
  {
      if (paths.Length == 1) {
          fullPath := paths[0];
          assert |fullPath| >= |paths[0]|;
      } else {
          fullPath := paths[0];
          assert fullPath == paths[0];
          assert |fullPath| >= |paths[0]|;
          for i := 1 to paths.Length - 1 {
              var oldLength := |fullPath|;
              // assert fullPath == paths[0];
              // assert |fullPath| == |paths[0]|;
              // assert oldLength == |paths[0]|;
              fullPath := fullPath + separator + paths[i];
              assert |fullPath| == oldLength + |separator| + |paths[i]|;
              assert |fullPath| >= |paths[i]|;
              // assert fullpath == paths[0];
          }
      }
  }

  method IsSymbolicLink(p: path) returns (isLink: bool)
    requires is_absolute_path(p)
    requires is_canonical_path(p) // srcLink -> dstLink
    ensures isLink ==> is_absolute_path(p) && is_canonical_path(p)
    ensures !isLink ==> !is_absolute_path(p) || !is_canonical_path(p)
  {
    isLink := is_absolute_path(p) && is_canonical_path(p);
  }
