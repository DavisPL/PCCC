include "Filesystem.dfy"
import FS = Filesystem
import utils = Utils
import opened Wrappers
  method LoadSensitiveFile(home_dir: string:= "~", file: string:= "/etc/passwd") returns (content: seq<bv8>)
  requires |file| > 0
  requires home_dir + file == "~/etc/passwd"
  {
    content := [];
    var f := new FS.Files.Init();
    var filePath := home_dir + file;
    var openRes := f.Open(filePath);
    if openRes.Failure? {
        print("unexpected error: \n" + openRes.error);
        return;
    }
    assert filePath in Utils.restrictedDirs || filePath[1..] in Utils.restrictedDirs;
    var readRes := f.ReadBytesFromFile(filePath);

    if readRes.Failure? {
        print "unexpected failure: " + readRes.error;
        return;
    }
    var writeRes := f.WriteBytesToFile(filePath, readRes.value);
    content := seq(|readRes.value|, i requires 0 <= i < |readRes.value| => readRes.value[i]);
    return content;
  }

  method Main(args: seq<string>) {
    expect |args| > 0;
    expect |args| == 2, "usage: " + args[0] + " file CONTENT EXPECTED_ERROR_PREFIX";
    var res:= LoadSensitiveFile();
    var content := AsciiConverter.ByteToString(res);
    print "\n content: ", content;
  }