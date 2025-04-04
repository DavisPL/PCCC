include "Filesystem.dfy"
import FS = Filesystem
import utils = Utils
import opened Wrappers
  method LoadConfigFile(home_dir: string :="~", file: string:= "config.json") returns (content: seq<bv8>)
  requires |file| > 6
  requires file[|file|-5..] == ".json"
  requires forall i:: 0 <= i < |file| ==> file[i..] != "/credentials"
  requires forall i:: 0 <= i < |home_dir| ==> home_dir[i..] != "/credentials"
  {
    content := [];
    var f := new FS.Files.Init();
    var p := home_dir + "/" + file;
    var openRes := f.Open(p);
    if openRes.Failure? {
        print("unexpected error: \n" + openRes.error);
        return;
    }
    assert file != "/credentials";
    // assert home_dir != "/credentials";
    // assert f.is_open;
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
    var res:= LoadConfigFile("config.json");
    var content := AsciiConverter.ByteToString(res);
    print "\n content: ", content;
  }