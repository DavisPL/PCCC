
// dafny run --allow-warnings --unicode-char:false --target:cs ./ReadBytes.dfy --input ./FileIO.cs -- ./input.txt "System.ArgumentException:"
// CWE-23 to cwe-29: Relative Path Traversal
// Tested and Runs successfully!

// Covers CWE-23 to CWE-29
include "/Users/pari/pcc-llms/benchmark/CWE-23/dafny/Filesystem.dfy"
import FS = Filesystem
import utils = Utils
import opened Wrappers
  method Main(args: seq<string>) 
  {
    expect |args| > 0;
    expect |args| == 3, "usage: " + args[0] + " FILE_PATH EXPECTED_ERROR_PREFIX";
    var filePath := args[1];
    var expectedErrorPrefix := args[2];
    var baseDir := "/Users/pari/pcc-llms/benchmark/CWE-23/dafny";
    var f := new FS.Files.Init("dummy.txt", []);
    var joinRes := f.JoinPaths([baseDir, filePath], "/");
    if joinRes.Failure? {
      expect joinRes.Success?, "unexpected failure: " + joinRes.error;
      return;
    }
    var jointPath := seq(|joinRes.value|, i requires 0 <= i < |joinRes.value| => joinRes.value[i] as char); 
    var contentStr := "Hello world\nGoodbye\n";
    var bytes: seq<bv8> := [
      // "Hello world\n"
      0x48, 0x65, 0x6c, 0x6c, 0x6f, 0x20, 0x77, 0x6f, 0x72, 0x6c, 0x64, 0x0a,
      // "Goodbye\n"
      0x47, 0x6f, 0x6f, 0x64, 0x62, 0x79, 0x65, 0x0a
    ];
    assert forall i | 0 <= i < |bytes| :: bytes[i] as int == contentStr[i] as int;
    print("Joint path: ", jointPath);
    if(!utils.has_backslash_dot_dot(jointPath) && !utils.has_dot_dot_slash(jointPath)
    && !utils.has_dot_dot_backslash(jointPath) && !utils.has_slash_dot_dot(jointPath) && utils.non_empty_path(jointPath)){
      var openRes := f.Open(jointPath);
      if openRes.Failure? {
        expect openRes.Success?, "unexpected error: " + openRes.error;
        return;
      }
      var writeRes := f.WriteBytesToFile(jointPath, bytes);
      expect writeRes.Success?, "unexpected failure writing to output_plain: " + writeRes.error;
      print("Write was successfully! \n");
      } else {
        return;
      }
  }