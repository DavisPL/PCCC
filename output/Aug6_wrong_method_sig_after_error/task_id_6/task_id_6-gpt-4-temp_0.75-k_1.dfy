include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreatePath(fileName: seq<char>) returns (fullFilePath: seq<char>)
 requires is_valid_file_extension(fileName)
 requires is_valid_file_name(fileName)
 requires has_valid_file_length(fileName)
 requires non_empty_string(fileName)
 requires !has_dangerous_pattern(fileName)
{
  var baseDirectory: seq<char> := "/home/user/documents";
  fullFilePath := Join(baseDirectory, fileName);
}