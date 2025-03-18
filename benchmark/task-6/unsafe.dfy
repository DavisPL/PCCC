include "Filesystem.dfy"
import FS = Filesystem
import utils = Utils
import opened Wrappers
  method LoadTextFile(file: string:= "~/protected-file.txt") returns (content: seq<char>)
  {
    content := [];
    var f := new FS.Files.Init();
    var openRes := f.Open(file);
    if openRes.Failure? {
        print("unexpected error: \n" + openRes.error);
        return;
    }
    var validContent := false;
    validContent, content := f.validateFileContent(file);
    if !validContent {
      print "unexpected error: invalid content";
      return [];
    }
    return content;
  }

  method Main(args: seq<string>) {
    expect |args| > 0;
    expect |args| == 2, "usage: " + args[0] + " file CONTENT EXPECTED_ERROR_PREFIX";
    var content:= LoadTextFile();
    print "\n content: ", content;
  }