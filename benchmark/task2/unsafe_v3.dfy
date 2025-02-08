
// dafny run --allow-warnings --unicode-char:false --target:cs ./ReadBytes.dfy --input ./FileIO.cs -- ./input.txt "System.ArgumentException:"
// CWE-22: Improper Limitation of a Pathname to a Restricted Directory ('Path Traversal')
// Tested and Runs successfully!
include "/Users/pari/pcc-llms/benchmark/task2/Filesystem.dfy"
import FS = Filesystem
import utils = Utils
import opened Wrappers

  method Main(args: seq<string>) 
  {
    expect |args| > 0;
    expect |args| == 3, "usage: " + args[0] + " FILE_PATH EXPECTED_ERROR_PREFIX";
    var filePath := args[1];
    var expectedErrorPrefix := args[2];
    var baseDir := "/Users/pari/pcc-llms/benchmark/task2";
    var f := new FS.Files.Init("dummy.txt", []);
    var joinRes := f.JoinPaths([baseDir, filePath], "/");
    if joinRes.Failure? {
      print("unexpected failure: " + joinRes.error);
      return;
    }
    var jointPath := seq(|joinRes.value|, i requires 0 <= i < |joinRes.value| => joinRes.value[i] as char); 
    // The following line test for empty expected bytes
    var expectedStr := "";
    var expectedBytes := seq(|expectedStr|, i requires 0 <= i < |expectedStr| => expectedStr[i] as int);
    print("Joint path: ", jointPath);
    if(!utils.has_dangerous_pattern(jointPath) && utils.non_empty_path(jointPath)){
      var openRes := f.Open(jointPath);
      if openRes.Failure? {
        print("unexpected error: " + openRes.error);
        return;
        }
        var readRes := f.ReadBytesFromFile(jointPath);
        if readRes.Failure? {
          print("unexpected failure: " + readRes.error);
          var readResEmpty := f.ReadBytesFromFile("");
          if (readResEmpty.Failure?) {
            print("unexpected success");
            if (expectedErrorPrefix <= readResEmpty.error) {
            print("unexpected error message: " + readResEmpty.error);
          }
        } 
      } else {
        var readBytes := seq(|readRes.value|, i requires 0 <= i < |readRes.value| => readRes.value[i] as int);
        expect readBytes == expectedBytes, "read unexpected byte sequence";
      } 
      print("File read successfully! \n");
      print("File content: \n " + expectedStr);
      } else {
        return;
      }
  }