include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreateFullPath(fileName: seq<char>) returns (fullPath: seq<char>)
 requires !has_dangerous_pattern(fileName)
 requires is_valid_file_name(fileName)
 requires has_valid_file_length(fileName)
 {
    var directory: seq<char> := "/home/user/documents";
    requires !has_dangerous_pattern(directory)
    requires is_valid_path_name(directory)
    requires has_valid_path_length(directory)
    requires has_valid_path_length(directory + fileName)
    requires append_file_to_path(directory, fileName) == directory + fileName
    fullPath := Join(directory, fileName);
 }