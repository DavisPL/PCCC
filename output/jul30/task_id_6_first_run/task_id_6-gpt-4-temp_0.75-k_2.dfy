include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method FullFilePath(fileName: seq<char>) returns (fullPath: seq<char>)
requires !IsDangerousPath(fileName)
requires IsValidFileName(fileName)
requires HasValidFileLength(fileName)
{
    var directory: seq<char> := "/home/user/documents";
    requires IsValidPathName(directory)
    requires HasValidPathLength(directory)
    
    fullPath := directory + "/" + fileName;
}