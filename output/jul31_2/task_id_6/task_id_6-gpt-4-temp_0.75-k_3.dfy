include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreatePath(fileName: seq<char>) returns (fullPath: seq<char>)
  requires non_empty_string(fileName)
  requires !has_dangerous_pattern(fileName)
  requires is_valid_file_name(fileName)
  requires has_valid_file_length(fileName)
  requires is_valid_file_extension(fileName)
  {
    var dir: seq<char> := "home/user/documents/";
    fullPath := Append(dir, fileName);
  }