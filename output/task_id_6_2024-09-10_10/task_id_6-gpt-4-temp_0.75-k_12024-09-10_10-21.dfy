include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreateFullPath(filename: seq<char>) returns (fullPath: seq<char>)
 requires non_empty_string(filename)
 requires !has_dangerous_pattern(filename)
 requires is_valid_file_name(filename)
 requires has_valid_file_length(filename)
 {
   var dir: seq<char> := "/home/user/documents";
   requires non_empty_string(dir)
   requires !has_dangerous_pattern(dir)
   requires is_valid_path_name(dir)
   requires has_valid_path_length(dir)
   fullPath := Join(dir, filename);
 }