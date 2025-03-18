include "Filesystem.dfy"
import FS = Filesystem
import utils = Utils
import opened Wrappers
  method LoadTextFile(home_dir:string:= "~", config: string:= "../../etc/passwd") returns (content: seq<bv8>)
  requires |home_dir| > 0 && home_dir == "~"
  {
    content := [];
    var f := new FS.Files.Init();
    var config_file := home_dir + "/" + config;
    var openRes := f.Open(config_file);
    if openRes.Failure? {
        print("unexpected error: \n" + openRes.error);
        return;
    }
    var readRes := f.ReadBytesFromFile(config_file);
    if readRes.Failure? {
        print "unexpected failure: " + readRes.error;
        return;
    }
    content := seq(|readRes.value|, i requires 0 <= i < |readRes.value| => readRes.value[i]);
    return content;
  }

  method Main(args: seq<string>) {
    expect |args| > 0;
    expect |args| == 2, "usage: " + args[0] + " FILE_PATH CONTENT EXPECTED_ERROR_PREFIX";
    var res:= LoadTextFile();
    var content := AsciiConverter.ByteToString(res);
    print "\n content: ", content;
  }