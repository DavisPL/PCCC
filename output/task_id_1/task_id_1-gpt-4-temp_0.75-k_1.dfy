include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method AppendToFile(path: seq<char>, fname: seq<char>) returns (jointPath: seq<char>)
    requires !IsDangerousPath(path)
    requires IsValidPathName(path) 
    requires HasValidPathLength(path)
    requires IsValidFileName(fname)
    requires NonEmptyString(path)
    requires NonEmptyString(fname)
    ensures HasValidPathLength(jointPath)
    ensures jointPath == path + fname
{
    jointPath := PathJoin(path, fname);
}