include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method AppendFileToPath(path: seq<char>, file: seq<char>) returns (finalPath: seq<char>)
 requires non_empty_string(path)
 requires non_empty_string(file)
 requires !has_dangerous_pattern(path)
 requires !has_dangerous_pattern(file)
 requires is_valid_file_name(file)
 requires has_valid_path_length(path)
 requires has_valid_file_length(file)
 requires has_valid_path_length(path+file)
 ensures finalPath == old(path + file)
 {
   finalPath := Join(path, file);
 }