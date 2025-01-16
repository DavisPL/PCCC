
// dafny run --allow-warnings --unicode-char:false --target:cs ./ReadBytes.dfy --input ./FileIO.cs -- ./input.txt "System.ArgumentException:"
// CWE-22: Improper Limitation of a Pathname to a Restricted Directory ('Path Traversal')
// Tested and Runs successfully!


include "/Users/pari/pcc-llms/benchmark/CWE-22/dafny/Filesystem.dfy"
import FS = Filesystem
import utils = Utils
import opened Wrappers

  method Main(args: seq<string>) 
  {
    expect |args| > 0;
    expect |args| == 3, "usage: " + args[0] + " FILE_PATH EXPECTED_ERROR_PREFIX";
    var filePath := args[1];
    var expectedErrorPrefix := args[2];
    var expectedStr := "Hello!\nThis is a safe text and you are allowed to read this content\n";
    var expectedBytes := seq(|expectedStr|, i requires 0 <= i < |expectedStr| => expectedStr[i] as Utils.byte);
    if filePath == "" {
      expect false, "empty file path";
      return;
    }
    if |expectedBytes| == 0 {
      expect false, "empty byte sequence";
      return;
    }
    var f := new FS.Files.Init(filePath, expectedBytes);
    print("Joint path: ", filePath);
      var openRes := f.Open(filePath); // without the check for non-empty name string and dangerous pattern
      if openRes.Failure? {
        expect openRes.Success?, "unexpected error: " + openRes.error;
        return;
      }
      var readRes := f.ReadBytesFromFile(filePath);
      if readRes.Failure? {
        expect readRes.Success?, "unexpected failure: " + readRes.error;
        var readResEmpty := f.ReadBytesFromFile("");
        expect readResEmpty.Failure?, "unexpected success"; 
        expect expectedErrorPrefix <= readResEmpty.error, "unexpected error message: " + readResEmpty.error;
      } else {
        var readBytes := seq(|readRes.value|, i requires 0 <= i < |readRes.value| => readRes.value[i] as Utils.byte);
        expect readBytes == expectedBytes, "read unexpected byte sequence";
      } 
      print("File read successfully! \n");
      print("File content: \n " + expectedStr);
  }