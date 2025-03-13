include "Filesystem.dfy"
import FS = Filesystem
import utils = Utils
import opened Wrappers
  method LoadRSAKey(home_dir:string:= "~", key: string:= "id_rsa") returns (content: seq<int>)
  requires |home_dir| > 0 && home_dir == "~"
  requires |key| > 0 && key == "id_rsa"
  {
    content := [];
    var perm: FS.Permission := FS.Permission.Read;
    var f := new FS.Files.Init(home_dir, perm);
    var pub_rsa := home_dir + "/.ssh" + "/" + key + ".pub";
    assert pub_rsa == "~/.ssh/id_rsa.pub";
    var openRes := f.Open(pub_rsa);
    if openRes.Failure? {
        print("unexpected error: \n" + openRes.error);
        return;
    }
    var readRes := f.ReadBytesFromFile(pub_rsa);
    if readRes.Failure? {
        print "unexpected failure: " + readRes.error;
        return;
    }
    content := seq(|readRes.value|, i requires 0 <= i < |readRes.value| => readRes.value[i] as int);
    return content;
  }

  method Main(args: seq<string>) {
    expect |args| > 0;
    expect |args| == 2, "usage: " + args[0] + " FILE_PATH CONTENT EXPECTED_ERROR_PREFIX";
    var home_dir:= "~";
    var key:= "id_rsa";
    var res:= LoadRSAKey(home_dir, key);
  }