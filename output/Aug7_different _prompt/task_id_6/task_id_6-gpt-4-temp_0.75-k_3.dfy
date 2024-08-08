include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreateFullPath(fileName: seq<char>) returns (fullPath: seq<char>)
 requires non_empty_string(fileName)
 requires !has_dangerous_pattern(fileName)
 requires is_valid_file_name(fileName)
 requires has_valid_file_length(fileName)
 ensures  has_absoloute_path(fullPath)
 ensures  is_valid_path_name(fullPath)
 ensures  has_valid_path_length(fullPath)
 ensures  append_file_to_path("/home/user/documents", fileName) == fullPath
 {
     fullPath := Join("/home/user/documents", fileName);
 }