include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreateFullPath(filename: seq<char>) returns (fullPath: seq<char>)
  requires !IsDangerousPath(filename)
  requires HasAbsolutePath(filename)
  requires IsValidFileName(filename)
  requires HasValidFileLength(filename)
  {
   var dir: seq<char> := "/home/user/documents";
   var joinIsOk:bool;
   fullPath := f.Join(dir, filename);
  }
  "