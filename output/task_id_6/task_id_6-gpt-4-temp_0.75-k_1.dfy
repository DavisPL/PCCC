include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreateFullPath(filename: seq<char>) returns (fullPath: seq<char>)
requires NonEmptyString(filename)
requires !IsDangerousPath(filename)
requires HasValidFileLength(filename)
requires IsValidFileName(filename)
{
 var basePath: seq<char> := "/home/user/documents";
 fullPath := Path.Join(basePath, filename);
}"