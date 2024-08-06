include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method JoinPath(fname: seq<char>) returns (fullPath: seq<char>)
requires IsValidFileName(fname)
requires NonEmptyString(fname)
requires HasValidFileLength(fname)
ensures HasValidPathLength(fullPath) || 0 <= |fullPath|
ensures PathJoin("/home/user/documents", fname) == fullPath  || fullPath == ""
{
 fullPath := SafeJoinAPI("/home/user/documents", fname);
}