include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreateFullPath(filename: seq<char>) returns (fullPath: seq<char>)
  requires non_empty_string(filename)
  requires !has_dangerous_pattern(filename)
  requires has_absoloute_path(filename)
  requires is_valid_file_name(filename)
  requires has_valid_file_length(filename)
 {
     var directory: seq<char> := "/home/user/documents"; 
     fullPath := directory + "/" + filename;
 }