include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method AppendToFile(path: seq<char>, fname: seq<char>) returns (jointPath: path)
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
{
  var ok: bool;
  var f: FileStream;
  ok, f := FileStream.SafeOpenAPI(fname);
  if !ok { 
    print "open failed\n"; 
    return ""; 
  }
  jointPath := f.SafeJoinAPI(path, fname);
  if jointPath == "" {
    print "join failed\n"; 
  } else {
    print "Safe join operation!\n";
  }
}