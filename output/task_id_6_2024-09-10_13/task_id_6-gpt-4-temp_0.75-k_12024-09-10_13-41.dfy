include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreateFullPath(filename: seq<char>) returns (fullPath: seq<char>)
 requires !has_dangerous_pattern(filename)
 requires is_valid_file_name(filename)
 requires has_valid_file_length(filename)
 requires join_path_to_file("/home/user/documents", filename) == "/home/user/documents" + filename
 {
     fullPath := Join("/home/user/documents", filename);
 }