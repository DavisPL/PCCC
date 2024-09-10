include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreateFullPath(filename: seq<char>) returns (fullPath: seq<char>)
 requires is_valid_file_name(filename)
 requires has_valid_file_length(filename)
 requires non_empty_string(filename)
 requires !has_dangerous_pattern(filename)
 {
   var directoryPath := "/home/user/documents";
   fullPath := Join(directoryPath, filename);
 }