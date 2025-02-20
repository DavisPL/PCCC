
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
    expect |args| > 0;
    expect |args| == 3, "usage: " + args[0] + " FILE_PATH CONTENT EXPECTED_ERROR_PREFIX";
    var filePath := args[1];
    var expectedErrorPrefix := args[2];
    var baseDir := "/Users/pari/pcc-llms/benchmark/task5";
    var f := new FS.Files.Init("dummy.txt", []);
    var joinRes := f.JoinPaths([baseDir, filePath], "/");
    expect joinRes.Success?, "unexpected failure: " + joinRes.error;
    var jointPath := seq(|joinRes.value|, i requires 0 <= i < |joinRes.value| => joinRes.value[i] as char); 
    var expectedStr := "Hello!\nThis is a safe text and you are allowed to read this content\n";
    var expectedBytes := seq(|expectedStr|, i requires 0 <= i < |expectedStr| => expectedStr[i] as int);
    print("Joint path: ", jointPath);
    var pathCheck := f.PathIsInsideBase(baseDir, jointPath);
    expect (!utils.has_dot_dot_slash(jointPath) && utils.non_empty_path(jointPath) && pathCheck);
    var openRes := f.Open(jointPath);
    expect openRes.Success?, "unexpected error: " + openRes.error;
    var readRes := f.ReadBytesFromFile(jointPath);
    expect readRes.Success?, "unexpected failure: " + readRes.error;
    var readBytes := seq(|readRes.value|, i requires 0 <= i < |readRes.value| => readRes.value[i] as int);
    expect readBytes == expectedBytes, "read unexpected byte sequence";
    print("File read successfully! \n");
    print("File content: \n " + expectedStr);

  }