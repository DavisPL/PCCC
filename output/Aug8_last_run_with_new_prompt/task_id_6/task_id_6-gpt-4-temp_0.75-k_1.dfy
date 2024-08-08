include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreateFullPath(filename: seq<char>) returns (fullpath: seq<char>)
 requires is_valid_file_name(filename)
 requires !has_dangerous_pattern(filename)
 requires has_valid_file_length(filename)
 {
   var directory: seq<char> := "/home/user/documents";
   requires is_valid_path_name(directory);
   requires !has_dangerous_pattern(directory);
   requires has_valid_path_length(directory);
   requires has_absoloute_path(directory);
   fullpath := Join(directory, filename);
 }