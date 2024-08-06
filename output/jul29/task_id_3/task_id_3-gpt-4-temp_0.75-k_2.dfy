include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method Append(path: seq<char>, fname: seq<char>) returns (jointPath: seq<char>)
  requires !IsDangerousPath(fname)
  requires !IsDangerousPath(path)
  requires HasAbsolutePath(fname)
  requires IsValidPathName(path)
  requires IsValidFileName(fname)
  requires HasValidFileLength(fname)
  requires HasValidPathLength(path)
  requires HasValidPathLength(path + fname)
  ensures PathJoin(path, fname) == jointPath  || jointPath == ""
  ensures HasValidPathLength(jointPath) || jointPath == ""
{
  // Open the file
  var ok: bool;
  var f: FileStream;
  ok, f := FileStream.SafeOpenAPI(fname);
  if (!ok) {
    print "Failed to open file\n";
    return;
  }

  // Append file to path
  jointPath := SafeJoinAPI(path, f);
  if (!HasValidPathLength(jointPath)) {
    print "Path name is too long\n";
    jointPath := "";
  }

  // Close the file
  ok := f.SafeCloseAPI();
  if (!ok) {
    print "Failed to close file\n";
  }
}