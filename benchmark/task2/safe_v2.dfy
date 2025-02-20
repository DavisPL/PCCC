
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
    var fileName := args[1];
    var expectedErrorPrefix := args[2];
    var baseDir := "/Users/pari/pcc-llms/benchmark/CWE-22";
    var f := new FS.Files.Init("dummy.txt", []);
    var joinRes := f.JoinPaths([baseDir, fileName], "/");
    expect joinRes.Success?, "unexpected failure: " + joinRes.error;
    var jointPath := seq(|joinRes.value|, i requires 0 <= i < |joinRes.value| => joinRes.value[i] as char); 
    var expectedStr := "This is a safe text and you are allowed to read this content";
    var expectedBytes := seq(|expectedStr|, i requires 0 <= i < |expectedStr| => expectedStr[i] as int);
    expect |expectedBytes| > 0, "empty byte sequence";
    expect |fileName| > 0, "empty file path";
    print("Joint path: ", jointPath);
    expect !utils.has_relative_traversal_pattern(jointPath) && utils.non_empty_path(jointPath), "unsafe file path";
    var openRes := f.Open(jointPath);
    expect openRes.Success?, "unexpected error: " + openRes.error;
    var readRes := f.ReadBytesFromFile(jointPath);
    expect readRes.Success?, "unexpected failure: " + readRes.error;
    var readBytes := seq(|readRes.value|, i requires 0 <= i < |readRes.value| => readRes.value[i] as int);
    expect readBytes == expectedBytes, "read unexpected byte sequence";
    print("File read successfully! \n");
    print("File content: \n " + expectedStr);
  }