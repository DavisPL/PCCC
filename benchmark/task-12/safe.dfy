include "Filesystem.dfy"
import FS = Filesystem
import utils = Utils
import opened Wrappers
  method StoreData(home_dir:string:= "~", file_1:string:="user-profile.txt", content:string:= "This is a safe content") returns (res: seq<char>)
  requires |home_dir| > 0 && home_dir == "~"
  requires |file_1| > 0 
  requires |content| > 0
  requires forall i:: 0 <= i < |content| ==> 'a' <= content[i] <= 'z' || 'A' <= content[i] <= 'Z' || '0' <= content[i] <= '9' || content[i] == ' ' || content[i] == '.' || content[i] == '!' || content[i] == '?'
  {
    var content1 := [];
    var contentBytes2 := [];
    var content2 := [];
    var f1 := new FS.Files.Init();
    var f2 := new FS.Files.Init();
    var p1 := home_dir + "/" + file_1;
    var openRes1 := f1.OpenWithAccessMode(p1, FS.Access.Read);
    if openRes1.Failure? {
        print("unexpected error in opening file: \n" + openRes1.error);
        return [];
    }
    var readRes1 := f1.ReadBytesFromFile(p1);
    if readRes1.Failure? {
        print "unexpected failure in reading file: " + readRes1.error;
        return [];
    }
    content1 := AsciiConverter.strToByte(content);
    var openRes2 := f2.OpenWithAccessMode(p1, FS.Access.Write);
    if openRes2.Failure? {
        print("unexpected error in opening file: \n" + openRes2.error);
        return [];
    }

    var writeRes2:= f2.WriteBytesWithAccessMode(p1, content1, FS.Access.Write);
    if writeRes2.Failure? {
        print "unexpected failure in writing file: " + writeRes2.error;
        return [];
    }
    print "writeRes2: ", writeRes2.value;
    var openRes3 := f2.OpenWithAccessMode(p1, FS.Access.Read);
    if openRes3.Failure? {
        print("unexpected error in opening file: \n" + openRes3.error);
        return [];
    } else {
      var readRes2 := f2.ReadBytesFromFile(p1);
      if readRes2.Failure? {
          print "unexpected failure in reading file: " + readRes2.error;
          return [];
      }
      contentBytes2 := seq(|readRes2.value|, i requires 0 <= i < |readRes2.value| => readRes2.value[i]);
      content2 := AsciiConverter.ByteToString(contentBytes2);
    }
    return content2;
  }

  method Main(args: seq<string>) {
    expect |args| > 0;
    expect |args| == 2, "usage: " + args[0] + " FILE_PATH CONTENT EXPECTED_ERROR_PREFIX";
    var res:= StoreData();
    print "\n result of Store: ", res;
  }