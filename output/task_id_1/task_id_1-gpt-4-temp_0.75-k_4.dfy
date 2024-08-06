include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method Append(path: seq<char>, fname: seq<char>) returns (jointPath: seq<char>)
  requires !IsDangerousPath(path)
  requires IsValidPath(path)
  requires IsValidFileName(fname)
  requires GetPathLength(path) + GetPathLength(fname) <= MAX_PATH_LENGTH
  ensures jointPath == PathJoin(path, fname)
  ensures GetPathLength(jointPath) <= MAX_PATH_LENGTH
{
  jointPath := PathJoin(path, fname);
}