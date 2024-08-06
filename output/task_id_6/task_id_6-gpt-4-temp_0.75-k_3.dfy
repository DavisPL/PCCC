include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method FullPath(filename: seq<char>) returns (fullpath: seq<char>)
 requires !has_dangerous_pattern(filename)
 requires is_valid_file_name(filename)
 requires non_empty_string(filename)
 requires has_valid_file_length(filename)
 requires is_valid_file_extension(filename)
 {
   var directory: seq<char> := "/home/user/documents";
   fullpath := Join(directory, filename);
 }