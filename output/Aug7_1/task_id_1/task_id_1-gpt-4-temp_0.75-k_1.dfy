include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method AppendToFile(path: seq<char>,  file: seq<char>) returns (jointPath: seq<char>)
 requires !has_dangerous_pattern(file)
 requires !has_dangerous_pattern(path)
 requires has_absoloute_path(file)
 requires is_valid_path_name(path)
 requires is_valid_file_name(file)
 requires has_valid_file_length(file)
 requires has_valid_path_length(path)
 requires has_valid_path_length(path + file)
 requires append_file_to_path(path, file) == path + file
 {
   jointPath := Join(path, file);
 }