include "Filesystem.dfy"
import FS = Filesystem
import utils = Utils
import opened Wrappers
  method loadTextFile(home_dir:string:= "~", config: string:= "user-profile.txt") returns (content: seq<bv8>)
  requires |home_dir| > 0 && home_dir == "~"
  requires |config| > 0 && config == "user-profile.txt"
  {
    content := [];
    var f := new FS.Files.Init();
    var config_file := home_dir + "/" + config;
    assert config_file == "~/user-profile.txt";
    var openRes := f.Open(config_file);
    if openRes.Failure? {
        print("unexpected error: \n" + openRes.error);
        return;
    }
    assert Utils.has_dot_dot_slash("~/user-profile.txt") == false;
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
    var res:= loadTextFile();
    var content := AsciiConverter.ByteToString(res);
    print "\n content: ", content;
  }