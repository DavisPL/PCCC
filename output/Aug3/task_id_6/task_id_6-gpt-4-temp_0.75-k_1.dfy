include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreateFilePath(filename: seq<char>, path: seq<char>) returns (fullFilePath: seq<char>)
 requires !has_dangerous_pattern(filename)
 requires !has_dangerous_pattern(path)
 requires has_absoloute_path(filename)
 requires has_absoloute_path(path)
 requires is_valid_file_name(filename)
 requires is_valid_path_name(path)
 requires has_valid_file_length(filename)
 requires has_valid_path_length(path)
 requires is_valid_file_extension(filename)
{
   var f: FileStream;
   var ok: bool;
   var joinIsOk:bool;
   fullFilePath := f.Join(path, filename);
}