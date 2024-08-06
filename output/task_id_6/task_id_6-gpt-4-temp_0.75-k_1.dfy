include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method MakePath(fname: seq<char>) returns (path: seq<char>)
 requires !has_dangerous_pattern(fname)
 requires is_valid_file_name(fname)
 requires has_valid_file_length(fname)
 requires is_valid_file_extension(fname)
 {
     var baseDir: seq<char> := "/home/user/documents/";
     path := JoinPath(baseDir, fname);
 }