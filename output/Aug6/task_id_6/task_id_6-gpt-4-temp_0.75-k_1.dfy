include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreateFullPath(filename: seq<char>) returns (full_path: seq<char>)
 requires !has_dangerous_pattern(filename)
 requires is_valid_file_name(filename)
 requires has_valid_file_length(filename)
 requires is_valid_file_extension(filename)
 ensures has_valid_path_length("/home/user/documents/"+filename)
 ensures append_file_to_path("/home/user/documents/", filename) == "/home/user/documents/" + filename
{
   full_path := Join("/home/user/documents/", filename);
}