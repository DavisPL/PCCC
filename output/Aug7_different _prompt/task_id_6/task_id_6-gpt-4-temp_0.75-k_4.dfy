include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreatePath(fileName: seq<char>) returns (fullPath: seq<char>)
 requires non_empty_string(fileName)
 requires !has_dangerous_pattern(fileName)
 requires is_valid_file_name(fileName)
 requires has_valid_file_length(fileName)
 {
   var directory: seq<char> := "/home/user/documents";
   fullPath := Join(directory, fileName);
 }