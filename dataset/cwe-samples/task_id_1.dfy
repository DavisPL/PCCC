include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

function GetFileName(): string
{
    // This method should return the filename
    "public-info.txt"
}

function GetPath(): string
{
    // This method should return the path
    "/user-data/"
}

method JoinFileToPath(path: seq<char>,  fname: seq<char>) returns (jointPath: path)
requires path == GetPath()
requires fname == GetFileName()
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