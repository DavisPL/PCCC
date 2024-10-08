include "/Users/pari/pcc-llms/filesystems-api/interface/effectful-interface.dfy"

method CreateFullPath(filename: seq<char>) returns (fullPath: seq<char>)
 requires !has_dangerous_pattern(filename)
 requires is_valid_file_name(filename)
 requires has_valid_file_length(filename)
 requires has_valid_path_length(filename)
 requires non_empty_string(filename)
 requires append_file_to_path("/home/user/documents", filename) == "/home/user/documents" + filename
 {
   fullPath := Join("/home/user/documents", filename);
 }