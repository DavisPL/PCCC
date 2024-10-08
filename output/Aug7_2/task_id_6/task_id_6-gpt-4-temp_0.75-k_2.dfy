include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method GenerateFullPath(filename: seq<char>) returns (fullpath: seq<char>)
 requires !has_dangerous_pattern(filename)
 requires is_valid_file_name(filename)
 requires has_valid_file_length(filename)
 requires has_valid_path_length('/home/user/documents' + filename)
 requires append_file_to_path('/home/user/documents', filename) == '/home/user/documents' + filename
 {
   fullpath := Join('/home/user/documents', filename);
 }