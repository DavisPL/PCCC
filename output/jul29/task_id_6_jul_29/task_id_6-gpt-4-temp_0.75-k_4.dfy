include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method AppendPath(fileName: seq<char>) returns (fullPath: seq<char>)
requires NonEmptyString(fileName)
requires IsValidFileName(fileName)
requires HasValidFileLength(fileName)
requires HasValidPathLength(PathJoin("/home/user/documents", fileName))
requires IsValidPathName(PathJoin("/home/user/documents", fileName))
requires !IsDangerousPath(PathJoin("/home/user/documents", fileName))
ensures fullPath == PathJoin("/home/user/documents", fileName)
{
    fullPath := SafeJoinAPI("/home/user/documents", fileName);
    print "Full path created: " + fullPath + "\n";
}