
// dafny run --allow-warnings --unicode-char:false --target:cs ./ReadBytes.dfy --input ./FileIO.cs -- ./input.txt "System.ArgumentException:"
// Tested and Runs successfully!

// Covers CWE-33 to CWE-35 double or multiple dot patterns with and without slashes and backslashes
include "/Users/pari/pcc-llms/benchmark/task4/Filesystem.dfy"
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
  var baseDir := "/Users/pari/pcc-llms/benchmark/task4";
  var f := new FS.Files.Init("dummy.txt", []);
  var expectedStr := "This is a safe text and you are allowed to read this content";
  var expectedBytes := seq(|expectedStr|, i requires 0 <= i < |expectedStr| => expectedStr[i] as int);
  if |filePath| == 0 {
    print("empty file path");
    return;
  }
  if |expectedBytes| == 0 {
    print("empty byte sequence");
    return;
  }
  var joinRes := f.JoinPaths([baseDir, filePath], "/");
  if joinRes.Failure? {
    print("unexpected failure: " + joinRes.error);
    return;
  }
  var jointPath := seq(|joinRes.value|, i requires 0 <= i < |joinRes.value| => joinRes.value[i] as char); 
  print("Joint path: ", jointPath);
  if(!utils.has_consecutive_dots(jointPath) && utils.non_empty_path(jointPath)){
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
    if (readBytes != expectedBytes) {
      print("read unexpected byte sequence");
      return;
    }
    print("File read successfully! \n");
    print("File content: \n " + expectedStr);
    } else {
      print("Empty or unsafe file path");
      return;
    }
}