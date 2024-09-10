include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreateFullPath(filename: seq<char>) returns(fullPath: seq<char>)
 requires !has_dangerous_pattern(filename)
 requires is_valid_file_name(filename)
 requires has_valid_file_length(filename)
 requires is_valid_path_name("/home/user/documents")
 requires non_empty_string(filename)
 requires non_empty_string("/home/user/documents")
 requires has_valid_path_length("/home/user/documents"+filename)
 {
   fullPath := Join("/home/user/documents", filename);
 }