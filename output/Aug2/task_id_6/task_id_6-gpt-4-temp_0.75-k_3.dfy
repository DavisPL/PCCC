include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreateFilePath(fileName: seq<char>) returns (filePath: seq<char>)
 requires !has_dangerous_pattern(fileName)
 requires is_valid_file_name(fileName)
 requires has_valid_file_length(fileName)
 requires is_valid_file_extension(fileName)
 {
     var f: FileStream;
     var ok: bool;
     var directory: seq<char> := "/home/user/documents"; // predetermined directory
     filePath := f.Join(directory, fileName);
 }