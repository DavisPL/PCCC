include "/Users/pari/pcc-llms/filesystems-api/interface/effectful-interface.dfy"

method CreateFullPath(filename: seq<char>) returns (fullPath: seq<char>)
 requires non_empty_string(filename)
 requires is_valid_file_name(filename)
 requires has_valid_file_length(filename)
 requires !has_dangerous_pattern(filename)
 {
   var directory: seq<char> := "/home/user/documents"; 
   requires is_valid_path_name(directory)
   requires has_valid_path_length(directory)
   requires has_absoloute_path(directory)
   requires !has_dangerous_pattern(directory)
   fullPath := Join(directory, filename);
 }