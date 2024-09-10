include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreateFullPath(filename: seq<char>) returns (fullPath: seq<char>)
 requires is_valid_file_name(filename)
 requires non_empty_string(filename)
 requires !has_dangerous_pattern(filename)
 requires has_valid_file_length(filename)
 {
     var path: seq<char> := "/home/user/documents";
     requires is_valid_path_name(path)
     requires non_empty_string(path)
     requires !has_dangerous_pattern(path)
     requires has_valid_path_length(path)
     fullPath := Join(path, filename);
 }