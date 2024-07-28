include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method AppendFileToPath(path: seq<char>, file: seq<char>) returns (jointPath: seq<char>)
requires !IsDangerousPath(path)
requires !IsDangerousPath(file)
requires IsValidPathName(path)
requires IsValidFileName(file)
requires NonEmptyString(path)
requires NonEmptyString(file)
requires HasValidPathLength(path)
requires HasValidFileLength(file)
ensures GetPathLength(jointPath) <= GetPathLength(path) + GetPathLength(file)
ensures HasValidPathLength(jointPath) || jointPath == []
{
  jointPath := PathJoin(path, file);
  assert HasValidPathLength(jointPath) || jointPath == [];
}