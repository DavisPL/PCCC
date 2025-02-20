
// dafny run --allow-warnings --unicode-char:false --target:cs ./ReadBytes.dfy --input ./FileIO.cs -- ./input.txt "System.ArgumentException:"
// CWE-22: Improper Limitation of a Pathname to a Restricted Directory ('Path Traversal')
// Tested and Runs successfully!


include "/Users/pari/pcc-llms/benchmark/task1/Filesystem.dfy"
import FS = Filesystem
import utils = Utils
import opened Wrappers

  method Main(args: seq<string>) 
  {
    expect |args| > 0;
    expect |args| == 3, "usage: " + args[0] + " FILE_PATH EXPECTED_ERROR_PREFIX";
    var filePath := args[1];
    var expectedErrorPrefix := args[2];
    var expectedStr := "This is a safe text and you are allowed to read this content";
    var expectedBytes := seq(|expectedStr|, i requires 0 <= i < |expectedStr| => expectedStr[i] as Utils.byte);
    var f := new FS.Files.Init(filePath, expectedBytes); // without the check for non-empty filepath input
    print("Joint path: ", filePath);
    if(!utils.has_dangerous_pattern(filePath) && utils.non_empty_path(filePath)){
      var openRes := f.Open(filePath);
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
    } else {
      print("unsafe file path");
      return;
    }
  }