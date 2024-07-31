include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreateFullPath(fileName: seq<char>) returns (fullPath: seq<char>)
  requires is_valid_file_name(fileName)
  requires !has_dangerous_pattern(fileName)
  requires non_empty_string(fileName)
  requires has_valid_file_length(fileName)
  requires is_valid_file_extension(fileName)
  {
    var dirPath: seq<char> := "/home/user/documents/";
    var f: FileStream;
    var ok: bool;
    ok, f := FileStream.Open(dirPath);
    if !ok { print "open failed"; return dirPath; }
    fullPath := f.Join(dirPath, fileName);
    print "Full path created";
    return fullPath;
}