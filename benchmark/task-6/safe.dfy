include "Filesystem.dfy"
import FS = Filesystem
import utils = Utils
import opened Wrappers
  method LoadTextFile(file: string:= "~/protected-file.txt") returns (content: seq<char>)
  requires |file| > 4
  requires Utils.extract_file_type(file[|file|-4..], ".txt")
  {
    content := [];
    var f := new FS.Files.Init();
    var openRes := f.Open(file);
    assert Utils.extract_file_type(file[|file|-|".txt"|..], ".txt");
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
    expect forall i: int :: 0 <= i < |content| ==> utils.is_valid_content_char(content[i]);
    return content;
  }

  method Main(args: seq<string>) {
    expect |args| > 0;
    expect |args| == 2, "usage: " + args[0] + " file CONTENT EXPECTED_ERROR_PREFIX";
    var content:= LoadTextFile();
    print "\n content: ", content;
  }