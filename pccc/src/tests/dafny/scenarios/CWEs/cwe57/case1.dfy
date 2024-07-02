include "../../../filestream/fileio_with_sensitive_files.dfy"

// Useful to convert Dafny strings into arrays of characters.
method ArrayFromSeq<A>(s: seq<A>) returns (a: array<A>)
  ensures a[..] == s
{
  a := new A[|s|] ( i requires 0 <= i < |s| => s[i] );
}

method {:main} Main(ghost env: HostEnvironment)
  requires env.ok.ok()
  modifies env.ok
{
  var fname := ArrayFromSeq("bar.txt");
  var f: FileStream;
  var ok: bool;

  ok, f := FileStream.Open(fname, env);
  // Try commenting out the following line to see that you are forced to handle errors!
  if !ok { print "open failed\n"; return; }


  if !ok { print "Write failed\n"; return; }
  var isOk:bool, okToJoin:bool, isCurDir :bool;
  var res: seq<char>;
  // okToJoin, res := f.Join("/Users/pari/pcc-llms/src/examples/../generated_codes", "foobar.txt");
  okToJoin, res := f.Join("/Users/pari/pcc-llms/src/playground/generated_codes", "foo.txt");
  // okToJoin, res := f.Join("/Users/pari/pcc-llms/src/examples/generated_codes", "foobar.txt");
  // isOk := f.GetCWD("/Users/pari/pcc-llms/src/examples/generated_codes");
  // isOk2 := f.GetCWD("/Users/pari/pcc-llms/src/examples/generated_code");
  var dirName1 := "/Users/pari/pcc-llms/src/playground/generated_codes";
  var dirName2 := "/Users/pari/pcc-llms/src/playground";

  isCurDir:= f.GetCWD(dirName1);
  print "done!\n";
}