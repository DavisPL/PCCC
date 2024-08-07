include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreateFullPath(fileName: seq<char>) returns (fullPath: seq<char>)
 requires !has_dangerous_pattern(fileName)
 requires is_valid_file_name(fileName)
 requires has_valid_file_length(fileName)
 {
   var directoryPath := "/home/user/documents";
   requires is_valid_path_name(directoryPath)
   requires has_valid_path_length(directoryPath)
   fullPath := Join(directoryPath, fileName);
 }