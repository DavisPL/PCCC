include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreatePath(fileName: seq<char>) returns (fullPath: seq<char>)
 requires NonEmptyString(fileName)
 requires IsValidFileName(fileName)
 requires HasValidFileLength(fileName)
 {
  const directory: seq<char> := "/home/user/documents";
  requires !IsDangerousPath(directory);
  requires IsValidPathName(directory);
  requires HasValidPathLength(directory);
  fullPath := directory + "/" + fileName;
}"