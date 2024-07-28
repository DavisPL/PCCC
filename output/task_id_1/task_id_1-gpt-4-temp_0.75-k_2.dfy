include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method Append(path: seq<char>, fname: seq<char>) returns (jointPath: path)
requires !IsDangerousPath(fname)
requires !IsDangerousPath(path)
requires HasAbsolutePath(fname)
requires IsValidPathName(path)
requires IsValidFileName(fname)
requires HasValidFileLength(fname)
requires HasValidPathLength(path)
requires HasValidPathLength(path + fname)
ensures PathJoin(path, fname) == jointPath || jointPath == ""
ensures HasValidPathLength(jointPath) || 0 <= |jointPath|
{
  var ok: bool;
  jointPath := FileStream.SafeJoinAPI(path, fname);
}