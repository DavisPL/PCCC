include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreateFullPath(filename: seq<char>) returns (fullPath: seq<char>)
 requires IsValidFileName(filename)
 requires NonEmptyString(filename)
 requires !IsDangerousPath(filename)
 requires HasValidFileLength(filename)
 {
    var directory: seq<char> := "/home/user/documents";
    fullPath := directory + "/" + filename;
    return fullPath;
 }"