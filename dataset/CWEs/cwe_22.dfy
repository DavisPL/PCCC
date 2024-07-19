include "/Users/pari/pcc-llms/dataset/filesystems/file-io-lib.dfy"



method WriteWithoutPathTraversal(ghost env: HostEnvironment)
  requires env.ok.ok()
  modifies env.ok
{

  var fileName := "safeFile-1.txt";
  var dir := "/Users/pari/pcc-llms/src/playground";
  var f: FileStream;
  var ok: bool;
  var okToJoin:bool;
  var res: seq<char>;
  var IsValidFile := ValidateFileName(fileName);
  if !IsValidFile 
  { print "Invalid file name\n"; return; }
  else {
    ok, f := FileStream.Open(fileName, env);
    // Try commenting out the following line to see that you are forced to handle errors!
    if !ok { print "open failed\n"; return; }
    // okToJoin, res := f.Join(dir, fileName);
    // This is "hello world!" in ascii.
    // The library requires the data to be an array of bytes, but Dafny has no char->byte conversions :(
    var data: array<byte> := ArrayFromSeq([104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 33, 10]);
    ok := f.Write(0, data, 0, data.Length as int32);
    if !ok { print "Write failed\n"; return; }

    // okToJoin, res := f.Join("/Users/pari/pcc-llms/src/examples/../generated_codes", "foobar.txt");

    // okToJoin, res := f.Join("/Users/pari/pcc-llms/src/examples/generated_codes", "foobar.txt");
    // isOk := f.GetCWD("/Users/pari/pcc-llms/src/examples/generated_codes");
    // isOk2 := f.GetCWD("/Users/pari/pcc-llms/src/examples/generated_code");
    var dirName1 := "/Users/pari/pcc-llms/src/examples/generated_codes";
    var dirName2 := "/Users/pari/pcc-llms/src/examples/generated_codes";

    // isEqual:= f.GetCWD(dirName1, dirName2);
    print "done!\n";
  }

}