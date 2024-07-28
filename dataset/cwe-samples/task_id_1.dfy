include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"
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
{
  var f: FileStream;
  var ok: bool;
  ok, f := FileStream.SafeOpenAPI(fname);
  if !ok { print "open failed\n"; return "";}
  var joinIsOk:bool;

  jointPath := f.SafeJoinAPI(path, fname);
}

method testAppend()
{
    var path: seq<char> := "/usr/data/";
    var fname: seq<char> := "file.txt";
    var a:= HasAbsolutePath(path);
    var jointPath := Append(path, fname);
    print "Generated Path: ", jointPath, "\n";
}