include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method MakeFullPath(filename: seq<char>) returns (fullPath: seq<char>)
 requires !has_dangerous_pattern(filename)
 requires is_valid_file_name(filename)
 requires has_valid_file_length(filename)
 ensures has_absoloute_path(fullPath)
 ensures is_valid_path_name(fullPath)
 ensures has_valid_path_length(fullPath)
{
    var directory: seq<char> := "/home/user/documents";
    fullPath := Join(directory, filename);
}