include "Filesystem.dfy"
import FS = Filesystem
import utils = Utils
import opened Wrappers
  method LoadTextFile(home_dir:string :="~", file: string:= "/user-profile.txt") returns (content: seq<bv8>)
  requires |file| > 0 && file == "/user-profile.txt"
  requires home_dir == "~"
  requires |home_dir| + |file| > 5
  {
    content := [];
    var p:= home_dir + file;
    var f := new FS.Files.Init();
    var openRes := f.Open(p);
    assert p == "~/user-profile.txt";
    assert p[1..6] == "/user";
    assert p[1..6] != "/etc/";
    assert p[0..5] != "/etc/";
    assert p[0..5] != "etc/";
    var forbiddenAccess := (p[1..6] == "/etc/" || p[0..5] == "/etc/" || p[0..5] == "etc/");
    assert !forbiddenAccess;
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