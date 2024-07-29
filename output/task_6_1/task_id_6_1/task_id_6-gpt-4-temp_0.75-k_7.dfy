include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreateFullPath(fname: seq<char>) returns (fullPath: seq<char>)
requires IsValidFileName(fname)
{
var baseDir := "/home/user/documents";
fullPath := SafeJoinAPI(baseDir, fname);
}