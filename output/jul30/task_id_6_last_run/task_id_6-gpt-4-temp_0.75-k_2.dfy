include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method SetFullPath(filename: seq<char>) returns (fullPath: seq<char>)
 requires !IsDangerousPath(filename)
 requires IsValidFileName(filename)
 requires HasValidFileLength(filename)
 {
  var basePath: seq<char> := "/home/user/documents";
  fullPath := Join(basePath, filename);
}"