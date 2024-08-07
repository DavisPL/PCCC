include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreateFullPath(filename: seq<char>) returns (fullFilePath: seq<char>)
 requires !has_dangerous_pattern(filename)
 requires is_valid_file_name(filename)
 requires has_valid_file_length(filename)
 {
   var directory: seq<char> := "/home/user/documents";
   requires !has_dangerous_pattern(directory)
   requires is_valid_path_name(directory)
   requires has_valid_path_length(directory)
   requires has_absoloute_path(directory)
   requires has_valid_path_length(directory + filename)
   requires append_file_to_path(directory, filename) == directory + filename

   fullFilePath := Join(directory, filename);
 }