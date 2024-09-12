include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreateFullPath(fileName: seq<char>) returns (fullPath: seq<char>)
  requires non_empty_string(fileName)
  requires !has_dangerous_pattern(fileName)
  requires is_valid_file_name(fileName)
  requires has_valid_file_length(fileName)
{
  var basePath: seq<char> := "/home/user/documents";
  requires non_empty_string(basePath)
  requires is_valid_path_name(basePath)
  requires has_absoloute_path(basePath)
  requires has_valid_path_length(basePath)
  requires has_valid_path_length(basePath + fileName)
  fullPath := Join(basePath, fileName);
}