include "../../../archive/interface/EffectfulInterface.dfy"

method CreateFullPath(fileName: seq<char>) returns (fullPath: seq<char>)
 requires !has_dangerous_pattern(fileName)
 requires is_valid_file_name(fileName)
 requires has_valid_file_length(fileName)
 {
   var path := "/home/user/documents";
   fullPath := Join(path, fileName);
 }