include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreateFullPath(filename: seq<char>) returns (fullPath: seq<char>)
 requires is_valid_file_name(filename)
 requires is_valid_file_extension(filename)
 requires non_empty_string(filename)
 requires !has_dangerous_pattern(filename)
 requires has_valid_file_length(filename)
 {
   var homeDir: seq<char> := "/home/user/documents"; 
   requires is_valid_path_name(homeDir)
   requires has_absoloute_path(homeDir)
   requires has_valid_path_length(homeDir)
   
   fullPath := Join(homeDir, filename);
 }