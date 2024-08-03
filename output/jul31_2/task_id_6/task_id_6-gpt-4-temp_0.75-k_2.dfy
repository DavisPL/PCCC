include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method fullFilePath(fileName: seq<char>) returns (fullPath: seq<char>)
  requires !has_dangerous_pattern(fileName)
  requires is_valid_file_extension(fileName)
  requires is_valid_file_name(fileName)
  requires non_empty_string(fileName)
  requires has_valid_file_length(fileName)
  {
      var dir: seq<char> := "/home/user/documents";
      var f: FileStream;
      var ok: bool;
      ok, f := FileStream.Open(dir);
      if !ok { print "open failed"; return; }
      fullPath := f.Join(dir, fileName);
  }