include "Filesystem.dfy"
import FS = Filesystem
import utils = Utils
import opened Wrappers
  method LoadFile(file: string:= "~/protected-file.txt") returns (content: seq<char>)
  requires |file| > 0 && file == "~/protected-file.txt"
  {
    content := [];
    var f := new FS.Files.Init();
    var openRes := f.Open(file);
    assert file == "~/protected-file.txt";
    assert Utils.extract_file_type(file[|file|-|".txt"|..], ".txt");
    if openRes.Failure? {
        print("unexpected error: \n" + openRes.error);
        return;
    }
    content := f.ReadFileContent(file);
    return content;
  }

  method Main(args: seq<string>) {
    expect |args| > 0;
    expect |args| == 2, "usage: " + args[0] + " file CONTENT EXPECTED_ERROR_PREFIX";
    var content:= LoadFile();
    print "\n content: ", content;
  }