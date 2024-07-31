include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method GenerateFullPath(fileName: seq<char>) returns (fullPath: seq<char>)
 requires !IsDangerousPath(fileName)
 requires IsValidFileName(fileName)
 requires HasValidFileLength(fileName)
 {
  var f: FileStream;
  var ok: bool;
  ok, f := FileStream.Open(fileName);
  if !ok { print "open failed
 "; return ""; }
  var directory: seq<char> := "/home/user/documents";
  fullPath := f.Join(directory, fileName);
}"