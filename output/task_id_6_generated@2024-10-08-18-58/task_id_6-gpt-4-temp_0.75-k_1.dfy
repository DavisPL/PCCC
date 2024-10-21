include "/Users/pari/pcc-llms/FilesystemsAPI/Interface/EffectfulInterface.dfy"

method CreateFullPath(filename: seq<char>) returns (fullPath: seq<char>)
  requires !has_dangerous_pattern(filename)
  requires non_empty_string(filename)
  requires is_valid_file_name(filename)
  requires has_valid_file_length(filename)
  requires is_valid_file_extension(filename)
 {
   var directory: seq<char> := "/home/user/documents";
   requires !has_dangerous_pattern(directory)
   requires non_empty_string(directory)
   requires is_valid_path_name(directory)
   requires has_valid_path_length(directory)
   requires has_absolute_path(directory)
   
   fullPath := Join(directory, filename);
 }