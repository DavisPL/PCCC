include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreateFullPath(filename: seq<char>) returns (fullPath: seq<char>)
 requires !has_dangerous_pattern(filename)
 requires is_valid_file_name(filename)
 requires has_valid_file_length(filename)
 {
     var baseDirectory: seq<char> := "/home/user/documents";
     requires !has_dangerous_pattern(baseDirectory);
     requires is_valid_path_name(baseDirectory);
     requires has_valid_path_length(baseDirectory);
     fullPath := Join(baseDirectory, filename);
 }