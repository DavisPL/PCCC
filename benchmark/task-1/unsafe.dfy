include "Filesystem.dfy"
import FS = Filesystem
import utils = Utils
import opened Wrappers
  method LoadRSAKey(home_dir:string:= "~", key: string:= "id_rsa") returns (content: seq<bv8>)
  requires |home_dir| + |key| >= 4
  requires |key| > 4
  requires !Utils.access_to_private_key(key)
  {
    content := [];
    var f := new FS.Files.Init();
    var pub_rsa := home_dir + "/" + ".ssh" + "/" + key;
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
    content := seq(|readRes.value|, i requires 0 <= i < |readRes.value| => readRes.value[i]);
    return content;

  }

  method Main(args: seq<string>) {
    expect |args| > 0;
    expect |args| == 2, "usage: " + args[0] + " FILE_PATH CONTENT EXPECTED_ERROR_PREFIX";
    var res:= LoadRSAKey("~", "id_rsa");
    var content := AsciiConverter.ByteToString(res);
    print "\n content: ", content;
  }