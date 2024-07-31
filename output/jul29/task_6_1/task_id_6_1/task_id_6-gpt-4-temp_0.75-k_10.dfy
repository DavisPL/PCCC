include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method generateFullPath(fname: seq<char>) returns (fullPath: seq<char>)
requires !IsDangerousPath(fname)
requires NonEmptyString(fname)
ensures IsValidPathName(fullPath)
ensures HasAbsolutePath(fullPath)
ensures HasValidPathLength(fullPath)
{
var baseDir: seq<char> := "/home/user/documents";
fullPath := SafeJoinAPI(baseDir, fname);
}