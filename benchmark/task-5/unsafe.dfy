include "Filesystem.dfy"
import FS = Filesystem
import utils = Utils
import opened Wrappers
  method LoadFile(home_dir:string:= "~", file: string:= "command.txt") returns (content: seq<char>)
  requires |home_dir| > 0 && home_dir == "~"
  requires |file| > 0
  {
    content := [];
    var f := new FS.Files.Init();
    var path := home_dir + file;
    var openRes := f.Open(path);
    if openRes.Failure? {
        print("unexpected error: \n" + openRes.error);
        return;
    }
    var readRes := f.ReadBytesFromFile(path);
    if readRes.Failure? {
      print "unexpected failure in reading file: " + readRes.error;
      return [];
    }
    content := AsciiConverter.ByteToString(seq(|readRes.value|, i requires 0 <= i < |readRes.value| => readRes.value[i]));
    return content;
  }
  
  method Main(args: seq<string>) {
    expect |args| > 0;
    expect |args| == 2, "usage: " + args[0] + " FILE_PATH CONTENT EXPECTED_ERROR_PREFIX";
    var content:= LoadFile();
    print "\n content: ", content;
  }