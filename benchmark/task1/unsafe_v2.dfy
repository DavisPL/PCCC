
// dafny run --allow-warnings --unicode-char:false --target:cs ./ReadBytes.dfy --input ./FileIO.cs -- ./input.txt "System.ArgumentException:"
// CWE-22: Improper Limitation of a Pathname to a Restricted Directory ('Path Traversal')
// Tested and Runs successfully!


include "/Users/pari/pcc-llms/benchmark/task1/Filesystem.dfy"
import FS = Filesystem
import utils = Utils
import opened Wrappers

  method Main(args: seq<string>) 
  {
    if |args| == 0 {
      print("empty arguments");
      return;
    }
    if |args| != 3 {
      print("usage: " + args[0] + " FILE_PATH EXPECTED_ERROR_PREFIX");
      return;
    }
    var filePath := args[1];
    var expectedErrorPrefix := args[2];
    var expectedStr := "This is a safe text and you are allowed to read this content";
    var expectedBytes := seq(|expectedStr|, i requires 0 <= i < |expectedStr| => expectedStr[i] as Utils.byte);
    if |filePath| == 0{
      print("empty file path");
      return;
    }
    if |expectedBytes| == 0 {
      print("empty byte sequence");
      return;
    }
    var f := new FS.Files.Init(filePath, expectedBytes);
    print("Joint path: ", filePath);
    var openRes := f.Open(filePath); // without verifying non-empty name string and dangerous pattern
    if openRes.Failure? {
      print("unexpected error: ", openRes.error);
      return;
    }
    var readRes := f.ReadBytesFromFile(filePath);
    if readRes.Failure? {
      print("unexpected failure: ", readRes.error);
      return;
    }
    var readBytes := seq(|readRes.value|, i requires 0 <= i < |readRes.value| => readRes.value[i] as Utils.byte);
    if readBytes != expectedBytes {
      print("read unexpected byte sequence");
      return;
    } 
    print("File read successfully! \n");
    print("File content: \n " + expectedStr);
  }