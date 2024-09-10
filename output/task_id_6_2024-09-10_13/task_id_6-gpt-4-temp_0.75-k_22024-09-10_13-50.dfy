include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreateFullPath(filename: seq<char>) returns(fullPath: seq<char>)
 requires is_valid_file_name(filename)
 requires non_empty_string(filename)
 requires !has_dangerous_pattern(filename)
 {
   var directoryPath: seq<char> := "/home/user/documents";
   requires has_valid_path_length(directoryPath)
   requires is_valid_path_name(directoryPath)
   requires !has_dangerous_pattern(directoryPath)
   fullPath := Join(directoryPath, filename);
 }