include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreatePath(filename: seq<char>) returns (fullPath: seq<char>)
 requires NonEmptyString(filename)
 requires !IsDangerousPath(filename)
 requires IsValidFileName(filename)
 requires HasValidFileLength(filename)
 {
  var path: seq<char> := "/home/user/documents";
  fullPath := path.Join(path, filename);
  print "Full path created!
 ";
}"