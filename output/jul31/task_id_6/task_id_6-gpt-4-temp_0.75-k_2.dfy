include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method ConstructFullPath(fileName: seq<char>) returns (fullPath: seq<char>)
 requires is_valid_file_name(fileName)
 requires non_empty_string(fileName)
 requires !has_dangerous_pattern(fileName)
 requires has_valid_file_length(fileName)
 requires is_valid_file_extension(fileName)
 {
     var path: seq<char> := "/home/user/documents";
     var f: FileStream;
     var ok: bool;
     ok, f := FileStream.Open(fileName);
     if !ok { print "open failed"; return; }
     fullPath := f.Join(path, fileName);
     print "Full path is constructed";
 }