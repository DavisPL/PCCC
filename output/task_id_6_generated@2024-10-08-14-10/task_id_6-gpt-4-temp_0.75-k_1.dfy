include "/Users/pari/pcc-llms/FilesystemsAPI/Interface/EffectfulInterface.dfy"

method CreateFullPath(filename: seq<char>) returns(fullPath: seq<char>)
requires is_valid_file_name(filename)
requires has_valid_file_length(filename)
requires !has_dangerous_pattern(filename)
{
  var directoryPath: seq<char> := "/home/user/documents";
  fullPath := Join(directoryPath, filename);
}