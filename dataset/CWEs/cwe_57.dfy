include "/Users/pari/pcc-llms/dataset/filesystems/effectful-interface/effectful-interface.dfy"

method {:main} Main(ghost env: HostEnvironment)
  requires env.ok.ok()
  modifies env.ok
{
  var fname := "bar.txt";
  var f: FileStream;
  var ok: bool;

  ok, f := FileStream.Open(fname, env);
  // Try commenting out the following line to see that you are forced to handle errors!
  if !ok { print "open failed\n"; return; }


  if !ok { print "Write failed\n"; return; }
  var isOk:bool, okToJoin:bool, isCurDir :bool;
  var res: seq<char>;
  // okToJoin, res := f.Join("/Users/pari/pcc-llms/src/examples/../generated_codes", "foobar.txt");
  // okToJoin, res := f.Join("/Users/pari/pcc-llms/src/playground/", "safeFile-1.txt");
  // okToJoin, res := f.Join("/Users/pari/pcc-llms/src/examples/generated_codes", "foobar.txt");
  // isOk := f.GetCWD("/Users/pari/pcc-llms/src/examples/generated_codes");
  // isOk2 := f.GetCWD("/Users/pari/pcc-llms/src/examples/generated_code");
  var dirName1 := "/Users/pari/pcc-llms/src/playground/generated_codes";
  var dirName2 := "/Users/pari/pcc-llms/src/playground";

  isCurDir:= f.GetCWD(dirName1);
  print "done!\n";
}