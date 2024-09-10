include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreateFullPath(filename: seq<char>) returns (fullPath: seq<char>)
 requires !has_dangerous_pattern(filename)
 requires is_valid_file_name(filename)
 requires has_valid_file_length(filename)
 requires non_empty_string(filename)
 {
   var path: seq<char> := "/home/user/documents"; // predetermined directory
   requires has_valid_path_length(path + filename);
   requires is_valid_path_name(path);
   requires non_empty_string(path);
   requires has_absoloute_path(path);
   fullPath := Join(path, filename);
 }