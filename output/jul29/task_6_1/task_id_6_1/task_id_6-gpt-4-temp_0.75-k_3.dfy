include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method BuildFilePath(fileName: seq<char>) returns (fullPath: seq<char>)
requires !IsDangerousPath(fileName)
requires NonEmptyString(fileName)
requires HasValidFileNameLength(fileName)
requires IsValidFileName(fileName)
ensures fullPath == "/home/user/documents" + fileName
ensures NonEmptyString(fullPath)
{
    var ok: bool;
    var fullFilePath: seq<char> := "/home/user/documents";
    fullPath := SafeJoinAPI(fullFilePath, fileName);
}