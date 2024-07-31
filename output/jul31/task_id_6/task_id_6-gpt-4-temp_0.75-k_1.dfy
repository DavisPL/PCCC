include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method createFilePath(filename: seq<char>) returns (fullpath: seq<char>)
  requires non_empty_string(filename)
  requires is_valid_file_name(filename)
  requires has_valid_file_length(filename)
  requires is_valid_file_extension(filename)
  {
    var directory: seq<char> := "/home/user/documents";
    var f: FileStream;
    var ok: bool;
    ok, f := FileStream.Open(directory);
    if ok {
      fullpath := f.Join(directory, filename);
    } else {
      print "Directory open failed";
      fullpath := "";
    }
}