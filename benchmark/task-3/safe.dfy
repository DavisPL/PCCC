include "Filesystem.dfy"
import FS = Filesystem
import utils = Utils
import opened Wrappers
  method compare(home_dir:string:= "~", file_1:string:="protected-file.txt", file_2:string:="user-profile.txt") returns (res: bool)
  requires |home_dir| > 0
  requires |file_1| > 3
  requires |file_2| > 3
  requires !utils.has_dot_dot_slash(file_1)
  requires !utils.has_dot_dot_slash(file_2)
  requires !utils.has_dot_dot_slash(home_dir)
  {
    var content2 := [];
    var content1 := [];
    var f1 := new FS.Files.Init();
    var f2 := new FS.Files.Init();
    var p1 := home_dir + "/" + file_1;
    var p2 := home_dir + "/" + file_2;
    var openRes1 := f1.Open(file_1);
    if openRes1.Failure? {
        print("unexpected error in opening file: \n" + openRes1.error);
        res := false;
        return;
    }
    var openRes2 := f2.Open(file_2);
    if openRes2.Failure? {
        print("unexpected error in opening file: \n" + openRes2.error);
        res := false;
        return;
    }
    assert p1 == home_dir + "/" + file_1;
    assert p1 == home_dir + "/" + file_1;
    assert f1.is_open;
    assert f2.is_open;
    var readRes1 := f1.ReadBytesFromFile(p1);
    if readRes1.Failure? {
        print "unexpected failure in reading file: " + readRes1.error;
        return false;
    }
    var readRes2 := f2.ReadBytesFromFile(p2);
    if readRes2.Failure? {
        print "unexpected failure in reading file: " + readRes2.error;
        return false;
    }
    content1 := seq(|readRes1.value|, i requires 0 <= i < |readRes1.value| => readRes1.value[i]);
    content2 := seq(|readRes2.value|, i requires 0 <= i < |readRes2.value| => readRes2.value[i]);
    return content1 == content2;
  }

  method Main(args: seq<string>)
  {
    expect |args| > 0;
    expect |args| == 2, "usage: " + args[0] + " FILE_PATH CONTENT EXPECTED_ERROR_PREFIX";
    assert !utils.has_dot_dot_slash("~");
    assert !utils.has_dot_dot_slash("protected-file.txt");
    assert !utils.has_dot_dot_slash("user-profile.txt");
    var res:= compare("~", "protected-file.txt", "user-profile.txt");
    print "\n Content of two files are identical: ", res;
  }