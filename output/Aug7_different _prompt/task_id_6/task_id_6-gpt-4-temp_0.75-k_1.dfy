include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreatePath(fileName: seq<char>) returns (fullPath : seq<char>)
  requires !has_dangerous_pattern(fileName)
  requires is_valid_file_name(fileName)
  requires has_valid_file_length(fileName)
  requires has_valid_path_length("/home/user/documents" + fileName)
  ensures  fullPath == "/home/user/documents" + fileName
{
  fullPath := Join("/home/user/documents", fileName);
}