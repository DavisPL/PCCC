include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreateFullPath(filename: seq<char>) returns (fullPath: seq<char>)
 requires non_empty_string(filename)
 requires is_valid_file_name(filename)
 requires !has_dangerous_pattern(filename)
 requires has_valid_file_length(filename)
 requires has_valid_path_length("/home/user/documents" + filename)
 {

     var directoryPath: seq<char> := "/home/user/documents";
     assert false;
     fullPath := Join(directoryPath, filename);
 }