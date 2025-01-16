
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
    var f := new FS.Files.Init("dummy.txt", []);
    var baseDir := "/Users/pari/pcc-llms/benchmark/CWE-22";
    var joinRes := f.JoinPaths([baseDir, filePath], "/");
    if joinRes.Failure? {
      expect joinRes.Success?, "unexpected failure: " + joinRes.error;
      return;
    }
    var jointPath := seq(|joinRes.value|, i requires 0 <= i < |joinRes.value| => joinRes.value[i] as char); 
    var expectedStr := "Hello!\nThis is a safe text and you are allowed to read this content\n";
    var expectedBytes := seq(|expectedStr|, i requires 0 <= i < |expectedStr| => expectedStr[i] as int);
    print("Joint path: ", jointPath);
    if(!utils.has_dangerous_pattern(jointPath) && utils.non_empty_path(jointPath)){
      var openRes := f.Open(jointPath);
      var readRes := f.ReadBytesFromFile(jointPath); // without the check for is_open
      if readRes.Failure? {
        expect readRes.Success?, "unexpected failure: " + readRes.error;
        var readResEmpty := f.ReadBytesFromFile("");
        expect readResEmpty.Failure?, "unexpected success";
        expect expectedErrorPrefix <= readResEmpty.error, "unexpected error message: " + readResEmpty.error;
      } else {
        var readBytes := seq(|readRes.value|, i requires 0 <= i < |readRes.value| => readRes.value[i] as int);
        expect readBytes == expectedBytes, "read unexpected byte sequence";
      } 
      print("File read successfully! \n");
      print("File content: \n " + expectedStr);
      } else {
        expect false, "unsafe file path";
        return;
      }
  }