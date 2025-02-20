
// dafny run --allow-warnings --unicode-char:false --target:cs ./ReadBytes.dfy --input ./FileIO.cs -- ./input.txt "System.ArgumentException:"
// CWE-23 to cwe-29: Relative Path Traversal
// Tested and Runs successfully!

// Covers CWE-23 to CWE-29
include "/Users/pari/pcc-llms/benchmark/task5/Filesystem.dfy"
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
    var baseDir := "/Users/pari/pcc-llms/benchmark/task5";
    var f := new FS.Files.Init("dummy.txt", []);
    var joinRes := f.JoinPaths([baseDir, filePath], "/");
    if joinRes.Failure? {
      print("unexpected failure: " + joinRes.error);
      return;
    }
    var jointPath := seq(|joinRes.value|, i requires 0 <= i < |joinRes.value| => joinRes.value[i] as char); 
    var expectedStr := "Hello!\nThis is a safe text and you are allowed to read this content\n";
    var expectedBytes := seq(|expectedStr|, i requires 0 <= i < |expectedStr| => expectedStr[i] as int);
    print("Joint path: ", jointPath);
      // {missing_specs}
    var openRes := f.Open(jointPath);
    if openRes.Failure? {
      print("unexpected error: " + openRes.error);
      return;
    }
    var readRes := f.ReadBytesFromFile(jointPath);
    if readRes.Failure? {
      print("unexpected failure: " + readRes.error);
      return;
    }
    var readBytes := seq(|readRes.value|, i requires 0 <= i < |readRes.value| => readRes.value[i] as int);
    print("File read successfully! \n");
    print("File content: \n " + expectedStr);
  }