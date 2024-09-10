include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreateFullPath(filename: seq<char>) returns (full_path: seq<char>)
 requires non_empty_string(filename)
 requires is_valid_file_name(filename)
 requires has_valid_file_length(filename)
 requires !has_dangerous_pattern(filename)
 {
   var dir_path : seq<char> := "/home/user/documents"; // predefined directory
   full_path := Join(dir_path, filename);
 }