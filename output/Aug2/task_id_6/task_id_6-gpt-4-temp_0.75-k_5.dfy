include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method ConstructFilePath(filename: seq<char>) returns(fullPath: seq<char>)
 requires is_valid_file_name(filename)
 requires non_empty_string(filename)
 requires !has_dangerous_pattern(filename)
 requires has_valid_file_length(filename)
 requires is_valid_file_extension(filename)
 {
   var rootPath := "/home/user/documents";
   var f: FileStream;
   fullPath := f.Join(rootPath, filename);
 }