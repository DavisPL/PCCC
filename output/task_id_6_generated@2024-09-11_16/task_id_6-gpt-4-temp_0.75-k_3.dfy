include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreateFullPath(filename: seq<char>) returns (fullPath: seq<char>)
 requires non_empty_string(filename)
 requires is_valid_file_name(filename)
 requires has_valid_file_length(filename)
 requires !has_dangerous_pattern(filename)
 {
  var baseDirectory: seq<char> := "/home/user/documents";
  requires is_valid_path_name(baseDirectory);
  requires has_valid_path_length(baseDirectory);
  requires !has_dangerous_pattern(baseDirectory);
  fullPath := Join(baseDirectory, filename);
 }