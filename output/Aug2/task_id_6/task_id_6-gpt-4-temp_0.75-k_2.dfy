include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method MakeFullPath(fileName: seq<char>) returns (fullPath: seq<char>)
 requires !has_dangerous_pattern(fileName)
 requires has_valid_file_length(fileName)
 requires is_valid_file_name(fileName)
 requires is_valid_file_extension(fileName)
 {
   var f: FileStream;
   var baseDirectory: seq<char> := "/home/user/documents";
   fullPath := f.Join(baseDirectory, fileName);
 }