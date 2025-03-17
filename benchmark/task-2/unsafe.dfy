include "Filesystem.dfy"
import FS = Filesystem
import utils = Utils
import opened Wrappers
  method LoadConfigFile(file:string:="/etc/passwd") returns (content: seq<bv8>)
  requires |file| > 0 && file == "/etc/passwd"
  {
    content := [];
    var f := new FS.Files.Init();
    assert file == "/etc/passwd";
    var openRes := f.Open(file);
    if openRes.Failure? {
        print("unexpected error: \n" + openRes.error);
        return;
    }
    var readRes := f.ReadBytesFromFile(file);
    if readRes.Failure? {
        print "unexpected failure: " + readRes.error;
        return;
    }
    content := seq(|readRes.value|, i requires 0 <= i < |readRes.value| => readRes.value[i]);
    return content;
  }

  method Main(args: seq<string>) {
    expect |args| > 0;
    expect |args| == 2, "usage: " + args[0] + " file CONTENT EXPECTED_ERROR_PREFIX";
    var res:= LoadConfigFile();
    var content := AsciiConverter.ByteToString(res);
    print "\n content: ", content;
  }