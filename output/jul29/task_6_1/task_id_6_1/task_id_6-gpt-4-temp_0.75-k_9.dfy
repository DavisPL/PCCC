include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreatePath(fname: seq<char>) returns (path: seq<char>)
requires !IsDangerousPath(fname)
requires HasAbsolutePath(fname)
requires IsValidFileName(fname)
requires HasValidFileLength(fname)
ensures IsValidPathName(path)
{
var dir: path := "/home/user/documents";
path := SafeJoinAPI(dir, fname);
}