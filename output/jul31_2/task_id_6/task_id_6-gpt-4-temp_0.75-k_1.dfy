include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreateFilePath(fileName: seq<char>) returns (path: seq<char>)
 requires !has_dangerous_pattern(fileName)
 requires is_valid_file_name(fileName)
 requires has_valid_file_length(fileName)
 requires is_valid_file_extension(fileName)
 {
  var directory: seq<char> := "/home/user/documents";
  var f: FileStream;
  var ok: bool;
  ok, f := FileStream.Open(directory);
  if !ok { print "open failed"; return ""; }
  path := f.Join(directory, fileName);
  print "File path created";
}