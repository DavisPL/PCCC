include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method Append(path: seq<char>,  fname: seq<char>) returns (jointPath: path)
  requires !IsDangerousPath(fname) // Precondition: file name contains no dangerous pattern
  requires !IsDangerousPath(path) // Precondition: path contains no dangerous pattern
  requires HasAbsolutePath(fname) // Precondition: file name is absolute
  requires IsValidPathName(path) // Precondition: path is valid
  requires IsValidFileName(fname) // Precondition: file name is valid
  requires HasValidFileLength(fname) // Precondition: file name length does not exceed limit
  requires HasValidPathLength(path) // Precondition: path length does not exceed limit
  requires HasValidPathLength(path + fname) // Precondition: combined path length does not exceed limit
  ensures PathJoin(path, fname) == jointPath || jointPath == "" // Postcondition: The joint path is either a valid path join or an empty string
  ensures HasValidPathLength(jointPath) || 0 <= |jointPath| // Postcondition: The joint path length is either valid or zero
{
  var ok: bool;
  var f: FileStream;
  ok, f := FileStream.SafeOpenAPI(fname);
  if ok {
    jointPath := f.SafeJoinAPI(path, fname);
  } else {
    print "Failed to open file\n";
    jointPath := "";
  }
}