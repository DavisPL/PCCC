include "../../../FilesystemsAPI/Interface/EffectfulInterface.dfy"

method CreateFullPath(filename: seq<char>) returns(fullPath: seq<char>)
 requires non_empty_string(filename)
 requires !has_dangerous_pattern(filename)
 requires is_valid_file_name(filename)
 requires has_valid_file_length(filename)
 {
   var dir: seq<char> := "/home/user/documents";
   fullPath := Join(dir, filename);
 }

method TestCreateFullPath()
{
    var filename: seq<char> := "../../etc/passwd";
    var fullPath: seq<char> := CreateFullPath(filename);
    print("Full path: ", fullPath);
}