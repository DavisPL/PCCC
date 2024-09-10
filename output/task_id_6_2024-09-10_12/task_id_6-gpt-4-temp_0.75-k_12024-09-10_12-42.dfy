include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreateFullPath(filename: seq<char>) returns (fullPath: seq<char>)
 requires !has_dangerous_pattern(filename)
 requires is_valid_file_name(filename)
 requires non_empty_string(filename)
 requires has_absoloute_path(filename)
 requires has_valid_file_length(filename)
 {
   var baseDir: seq<char> := "/home/user/documents";
   requires is_valid_path_name(baseDir)
   requires non_empty_string(baseDir)
   requires !has_dangerous_pattern(baseDir)
   requires has_absoloute_path(baseDir)
   requires has_valid_path_length(baseDir)
   requires has_valid_path_length(baseDir+filename)
   {
     fullPath := Join(baseDir, filename);
   }
 }