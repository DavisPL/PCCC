include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

requires !IsDangerousPath(fname) 
requires !IsDangerousPath(path)
requires HasAbsolutePath(fname)
requires IsValidPathName(path)
requires IsValidFileName(fname)
requires HasValidFileLength(fname)
requires HasValidPathLength(path)
requires HasValidPathLength(path + fname)
ensures PathJoin(path, fname) == jointPath  || jointPath == ""
ensures HasValidPathLength(jointPath) || 0 <= |jointPath|
method Append(path: seq<char>,  fname: seq<char>) returns (jointPath: path)
{
  var ok: bool;
  var f: FileStream;
  ok, f := FileStream.SafeOpenAPI(fname);
  if !ok { print "open failed\n"; jointPath := ""; return; }
  jointPath := f.SafeJoinAPI(path, fname);
}