
// dafny run --allow-warnings --unicode-char:false --target:cs ./ReadBytes.dfy --input ./FileIO.cs -- ./input.txt "System.ArgumentException:"
// CWE-23 to cwe-29: Relative Path Traversal
// Tested and Runs successfully!

// Covers CWE-23 to CWE-29
include "/Users/pari/pcc-llms/benchmark/task3/Filesystem.dfy"
import FS = Filesystem
import utils = Utils
import strConverter = AsciiConverter
import opened Wrappers
method Main(args: seq<string>) 
{
  if |args| == 0 {
  print("empty arguments");
  return;
  }
  if |args| != 4 {
    print("usage: " + args[0] + " FILE_PATH EXPECTED_ERROR_PREFIX");
    return;
  }
  var filePath := args[1];
  var contentStr := args[2];
  var expectedErrorPrefix := args[3];

  var baseDir := "/Users/pari/pcc-llms/benchmark/task3";
  var f := new FS.Files.Init("dummy.txt", []);
  var joinRes := f.JoinPaths([baseDir, filePath], "/");
  if joinRes.Failure? {
    print("unexpected failure: " + joinRes.error);
    return;
  }
  if !(utils.non_empty_string(contentStr)) {
    print ("Empty string!\n");
    return;
  }

  if !(utils.is_valid_content_str(contentStr)) {
    print ("Invalid content string!\n" + contentStr);
    return;
  }
    var jointPath := seq(|joinRes.value|, i requires 0 <= i < |joinRes.value| => joinRes.value[i] as char); 
    var bytes :seq<bv8> := strConverter.strToBytes(contentStr);
    print("Joint path: \n", jointPath + "\n");
  // {missing_specs}
    var openRes := f.Open(jointPath);
    if openRes.Failure? {
      print ("unexpected error: \n" + openRes.error);
      return;
    }
    var writeRes := f.WriteBytesToFile(jointPath, bytes);
    if writeRes.Failure? {
      print("unexpected failure writing to output_plain: \n" + writeRes.error);
      return;
    }
    print("Write to the input file " + filePath + " was successfully! \n"); 
}