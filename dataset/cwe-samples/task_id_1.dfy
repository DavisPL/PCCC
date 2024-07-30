include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"
<<<<<<< HEAD

method JoinFileToPath(path: seq<char>,  fname: seq<char>) returns (jointPath: path)
requires path == GetPath()
requires fname == GetFileName()
=======
method Append(path: seq<char>,  fname: seq<char>) returns (jointPath: path)
requires !IsDangerousPath(fname)
requires !IsDangerousPath(path)
requires HasAbsolutePath(fname)
requires IsValidPathName(path)
requires IsValidFileName(fname)
requires HasValidFileLength(fname)
requires HasValidPathLength(path)
requires HasValidPathLength(path + fname)
requires PathJoin(path, fname) == path + fname
ensures HasValidPathLength(jointPath)
>>>>>>> fb1cbe8e (updated)
{
  var f: FileStream;
  var ok: bool;
  ok, f := FileStream.Open(fname);
  if !ok { print "open failed\n"; return "";}
  var joinIsOk:bool;
  joinIsOk, jointPath := f.Join(path, fname);
}

method{:main} Main()
{
  var path := GetPath();
  var fname := GetFileName();
  var jointPath := JoinFileToPath(path, fname);
  print jointPath;
}