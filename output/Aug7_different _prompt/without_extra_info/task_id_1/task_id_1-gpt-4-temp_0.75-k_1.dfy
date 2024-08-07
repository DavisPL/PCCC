include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method AppendFileToPath(path: seq<char>,  fname: seq<char>) returns (jointPath: seq<char>)
 requires non_empty_string(fname)
 requires non_empty_string(path)
 requires !has_dangerous_pattern(fname)
 requires !has_dangerous_pattern(path)
 requires has_absoloute_path(fname)
 requires is_valid_path_name(path)
 requires is_valid_file_name(fname)
 requires has_valid_file_length(fname)
 requires has_valid_path_length(path)
 requires has_valid_path_length(path + fname)
 {
   jointPath := Join(path, fname);
 }