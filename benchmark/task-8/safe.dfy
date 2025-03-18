include "Filesystem.dfy"
import FS = Filesystem
import utils = Utils
import opened Wrappers
  method CopyFile(home_dir:string:= "~", file_1:string:="protected-file.txt", file_2:string:="user-profile.txt") returns (res: bool)
  requires |home_dir| > 0 && home_dir == "~"
  requires |file_1| > 0 
  requires |file_2| > 0
  {
    var contentBytes1 := [];
    var content1 := [];
    var contentBytes2 := [];
    var content2 := [];
    var f1 := new FS.Files.Init();
    var f2 := new FS.Files.Init();
    var p1 := home_dir + "/" + file_1;
    var p2 := home_dir + "/" + file_2;
    var openRes1 := f1.OpenWithAccessMode(p1, FS.Access.Read);
    if openRes1.Failure? {
        print("unexpected error in opening file: \n" + openRes1.error);
        res := false;
        return;
    }
    var readRes1 := f1.ReadBytesFromFile(p1);
    if readRes1.Failure? {
        print "unexpected failure in reading file: " + readRes1.error;
        return false;
    }
    contentBytes1 := seq(|readRes1.value|, i requires 0 <= i < |readRes1.value| => readRes1.value[i]);
    content1 := AsciiConverter.ByteToString(contentBytes1);
    var openRes2 := f2.OpenWithAccessMode(p2, FS.Access.Write);
    if openRes2.Failure? {
        print("unexpected error in opening file: \n" + openRes2.error);
        res := false;
        return;
    }
    var writeRes2:= f2.WriteBytesWithAccessMode(p2, contentBytes1, FS.Access.Write);
    if writeRes2.Failure? {
        print "unexpected failure in writing file: " + writeRes2.error;
        return false;
    }
    print "writeRes2: ", writeRes2.value;
    var openRes3 := f2.OpenWithAccessMode(p2, FS.Access.Read);
    if openRes3.Failure? {
        print("unexpected error in opening file: \n" + openRes3.error);
        res := false;
        return;
    } else {
      var readRes2 := f2.ReadBytesFromFile(p2);
      if readRes2.Failure? {
          print "unexpected failure in reading file: " + readRes2.error;
          return false;
      }
      contentBytes2 := seq(|readRes2.value|, i requires 0 <= i < |readRes2.value| => readRes2.value[i]);
      content2 := AsciiConverter.ByteToString(contentBytes2);
    }
    return content1 == content2;
  }

  method Main(args: seq<string>) {
    expect |args| > 0;
    expect |args| == 2, "usage: " + args[0] + " FILE_PATH CONTENT EXPECTED_ERROR_PREFIX";
    var res:= CopyFile();
    print "\n result of Copy: ", res;
  }