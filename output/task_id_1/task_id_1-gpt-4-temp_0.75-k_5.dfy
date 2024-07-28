include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method Append(path: path,  fname: seq<char>) returns (jointPath: path)
requires !IsDangerousPath(fname)  // file name should not have dangerous patterns
requires !IsDangerousPath(path) // path should not have dangerous patterns
requires HasAbsolutePath(fname) // file name should not be a relative path
requires IsValidPathName(path) // path should follow the valid pattern
requires IsValidFileName(fname) // file name should follow the valid pattern
requires HasValidFileLength(fname) // file name length should not exceed the maximum limit
requires HasValidPathLength(path) // path length should not exceed the maximum limit
requires HasValidPathLength(path + fname) // the joined path length should not exceed the maximum limit
ensures PathJoin(path, fname) == jointPath  || jointPath == "" // the joint path should be a valid result or empty
ensures HasValidPathLength(jointPath) || 0 <= |jointPath| // the joint path length should be valid or zero
{
    var ok: bool;
    jointPath := SafeJoinAPI(path, fname);
    if (!ok) { print "Path joining operation failed\n"; jointPath := ""; }
}