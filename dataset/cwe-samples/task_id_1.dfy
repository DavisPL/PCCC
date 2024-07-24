include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

function GetFileName(): string
{
    // This method should return the filename
    "public-key.txt"
}

function GetPath(): string
{
    // This method should return the path
    "/documents"
}

method SafeJoin(path: seq<char>,  fname: seq<char>) returns (jointPath: path)
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
