include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method GetFullPath(fileName: seq<char>) returns (fullPath: seq<char>)
  requires !has_dangerous_pattern(fileName)
  requires is_valid_file_name(fileName)
  requires non_empty_string(fileName)
  ensures  is_valid_path_name(fullPath) && isValidPathAndFileName(fullPath, fileName)
{
  var baseDir: seq<char> := "/home/user/documents";
  var f: FileStream;
  var ok: bool;
  ok, f := FileStream.Open(fileName);
  if !ok { print "open failed"; return; }
  fullPath := f.Join(baseDir, fileName);
}