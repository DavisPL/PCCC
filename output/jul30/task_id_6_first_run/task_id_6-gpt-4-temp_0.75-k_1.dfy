include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method GenerateFullPath(filename: seq<char>) returns (fullPath: path)
 requires NonEmptyString(filename)
 requires IsValidFileName(filename)
 requires HasValidFileLength(filename)
 requires !IsDangerousPath(filename)
 {
  var baseDirectory: path := "/home/user/documents";
  requires IsValidPathName(baseDirectory)
  requires HasValidPathLength(baseDirectory)
  requires HasAbsolutePath(baseDirectory)
  fullPath := baseDirectory + filename;
  print "Full path generated!
 ";
}"