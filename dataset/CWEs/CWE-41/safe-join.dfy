include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method SafeJoin(env: HostEnvironment, path: seq<char>,  fname: seq<char>)
  requires env.ok.ok()
  modifies env.ok
{
  var fname := "public-key.txt";
  var f: FileStream;
  var ok: bool;
  ok, f := FileStream.Open(fname, env);
  if !ok { print "open failed\n"; return;}
  var path := "/Users/pari/pcc-llms/src/playground";
  var joinIsOk:bool;
  var jointPath: seq<char>;
  assert fname == "public-key.txt";
  joinIsOk, jointPath := f.Join(path, fname);
  assert jointPath == "/Users/pari/pcc-llms/src/playground/public-key.txt";
  // var j : seq<char>  := "/Users/pari/pcc-llms/src/playground" + "/" + fname;
  // assert j == "/Users/pari/pcc-llms/src/playground/public-key.txt";
  // assert j == jointPath;
  // var j2 : seq<char> := path_join(path, fname);
  // assert j2 == j;
  // assert jointPath == "/Users/pari/pcc-llms/src/playground/safeFile-1.txt";
}