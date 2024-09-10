include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreateFullPath(filename: seq<char>) returns (fullPath: seq<char>)
 requires non_empty_string(filename)
 requires is_valid_file_name(filename)
 requires !has_dangerous_pattern(filename)
 requires has_valid_file_length(filename)
{
  var directoryPath: seq<char> := "/home/user/documents";
  requires non_empty_string(directoryPath)
  requires is_valid_path_name(directoryPath)
  requires !has_dangerous_pattern(directoryPath)
  requires has_valid_path_length(directoryPath)
  requires has_valid_path_length(directoryPath + filename)
  
  fullPath := Join(directoryPath, filename);
}