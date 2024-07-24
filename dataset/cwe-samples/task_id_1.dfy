include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"
method SafeJoin(path: seq<char>,  fname: seq<char>) returns (jointPath: path)
{
  var fname := "public-key.txt";
  var f: FileStream;
  var ok: bool;
  ok, f := FileStream.Open(fname);
  if !ok { print "open failed\n"; return "";}
  var path := "/documents";
  var joinIsOk:bool;
  assert fname == "public-key.txt";
  joinIsOk, jointPath := f.Join(path, fname);
  assert jointPath == "/documents/public-key.txt";
}