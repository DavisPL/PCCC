include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreateFullPath(fname: seq<char>) returns (fullPath: path)
 requires NonEmptyString(fname)
 requires IsValidFileName(fname)
 requires HasValidFileLength(fname)
 requires !IsDangerousPath(fname)
 {
  var baseDir: seq<char> := "/home/user/documents";
  requires IsValidPathName(baseDir)
  requires HasValidPathLength(baseDir)
  requires !IsDangerousPath(baseDir)
  fullPath := File.Join(baseDir, fname);
}"