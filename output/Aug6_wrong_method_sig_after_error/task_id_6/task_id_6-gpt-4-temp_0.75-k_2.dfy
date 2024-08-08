include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method GenerateFilePath(fileName: seq<char>) returns (fullPath: seq<char>)
  requires !has_dangerous_pattern(fileName)
  requires is_valid_file_name(fileName)
  requires has_valid_file_length(fileName)
{
  var directoryPath: seq<char> := seq("/home/user/documents");
  fullPath := Join(directoryPath, fileName);
}