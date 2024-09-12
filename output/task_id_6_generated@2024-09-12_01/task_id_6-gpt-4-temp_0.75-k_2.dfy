include "/Users/pari/pcc-llms/filesystems-api/interface/effectful-interface.dfy"

method CreateFullPath(filename: seq<char>) returns (fullPath: seq<char>)
 requires !has_dangerous_pattern(filename)
 requires is_valid_file_name(filename)
 requires has_valid_file_length(filename)
 requires non_empty_string(filename)
 {
   var directory: seq<char> := "/home/user/documents";
   fullPath := Join(directory, filename);
 }