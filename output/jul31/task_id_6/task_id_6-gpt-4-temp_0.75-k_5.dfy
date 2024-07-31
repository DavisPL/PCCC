include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreateFullPath(fileName: seq<char>) returns (fullPath: seq<char>)
  requires is_valid_file_name(fileName)
  requires has_valid_file_length(fileName)
  requires non_empty_string(fileName)
  requires !has_dangerous_pattern(fileName)
{
  var baseDirectory := "home/user/documents";
  var f: FileStream;
  var ok: bool;
  
  ok, f := FileStream.Open(baseDirectory);
  if !ok { print "open failed"; return; }
  
  fullPath := f.Join(baseDirectory, fileName);
}