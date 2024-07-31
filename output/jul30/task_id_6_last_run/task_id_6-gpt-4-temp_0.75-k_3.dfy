include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreateFullPath(filename: seq<char>) returns (fullPath: seq<char>)
 requires !IsDangerousPath(filename)
 requires IsValidFileName(filename)
 requires HasValidFileLength(filename)
 {
   var directory: seq<char> := "/home/user/documents";
   fullPath := directory + "/" + filename;
   assert HasValidPathLength(fullPath);
   assert IsValidPathName(fullPath);
   assert HasAbsolutePath(fullPath);
 }"