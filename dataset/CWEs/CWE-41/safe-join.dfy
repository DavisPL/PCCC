include "/Users/pari/pcc-llms/dataset/filesystems/effectful-interface/effectful-interface.dfy"

method {:main} Main(ghost env: HostEnvironment, path: seq<char>,  fname: seq<char>) returns (res: bool)
  requires env.ok.ok()
  modifies env.ok
  requires ValidateFileName(fname)
  requires IsValidFileType(fname[(|fname|-4)..], invalidFileTypes)
  requires ValidateNonsensitiveFileFunc(fname, nonSensitiveFilesList)
  ensures HasConsecutiveSameChars(path) && HasConsecutiveSameChars(path) <==> !res
{
  var fname := "bar.txt";
  var f: FileStream;
  var ok: bool;

  ok, f := FileStream.Open(fname, env);
  // Try commenting out the following line to see that you are forced to handle errors!
  if !ok { print "open failed\n"; res := false;}

  var okToJoin:bool;
  var jointPath: seq<char>;
  okToJoin, jointPath := f.Join("/home", "bar.txt");
//   assert jointPath == "/home/bar.txt";
//   assert res == "/Users/pari/pcc-llms/src/generated_codes/foobar.txt";
  // okToJoin, res := f.Join("/Users/pari/pcc-llms/src/playground/", "safeFile-1.txt");
  // okToJoin, res := f.Join("/Users/pari/pcc-llms/src/examples/generated_codes", "foobar.txt");
  // isOk := f.GetCWD("/Users/pari/pcc-llms/src/examples/generated_codes");
  // isOk2 := f.GetCWD("/Users/pari/pcc-llms/src/examples/generated_code");
  var dirName1 := "/Users/pari/pcc-llms/src/playground/generated_codes";
  var dirName2 := "/Users/pari/pcc-llms/src/playground";
  print "done!\n";
}