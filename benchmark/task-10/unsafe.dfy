include "Filesystem.dfy"
import FS = Filesystem
import utils = Utils
import opened Wrappers
  method LoadTextFile(home_dir:string :="~", file: string:= "/etc/passwd") returns (content: seq<bv8>)
  requires |file| > 0 && file == "/etc/passwd"
  requires home_dir == "~"
  requires |home_dir| + |file| > 5
  {
    content := [];
    var p:= home_dir + file;
    var f := new FS.Files.Init();
    var openRes := f.Open(p);
    if openRes.Failure? {
        print("unexpected error: \n" + openRes.error);
        return;
    }
    var readRes := f.ReadBytesFromFile(p);
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
    var res:= LoadTextFile();
    var content := AsciiConverter.ByteToString(res);
    print "\n content: ", content;
  }