include "../filestream/fileio_with_sensitive_files.dfy"

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

  // This is "hello world!" in ascii.
  // The library requires the data to be an array of bytes, but Dafny has no char->byte conversions :(
  var data: array<byte> := ArrayFromSeq([104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 33, 10]);

  ok := f.Write(0, data, 0, data.Length as int32);
  if !ok { print "Write failed\n"; return; }
  var isOk:bool, isOk2:bool, isOk3 :bool;
  var res: seq<char>;
  // isOk, res := f.Join("/Users/pari/pcc-llms/src/examples/../generated_codes", "foobar.txt");
  // isOk, res := f.Join("/Users/pari/pcc-llms/src/examples/generated_codes", "foobar.txt");
  // isOk, res := f.Join("/Users/pari/pcc-llms/src/examples/generated_codes", "foobar.txt");
  // isOk := f.GetCWD("/Users/pari/pcc-llms/src/examples/generated_codes");
  // isOk2 := f.GetCWD("/Users/pari/pcc-llms/src/examples/generated_code");
  var dirName1 := "/Users/pari/pcc-llms/src/examples/generated_codes";
  var dirName2 := "../Users/pari/pcc-llms/src/examples/generated_codes";

  isOk3 := f.checkCWD(dirName1, dirName2);
  print "done!\n";
}