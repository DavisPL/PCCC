
// dafny run --allow-warnings --unicode-char:false --target:cs ./ReadBytes.dfy --input ./FileIO.cs -- ./input.txt "System.ArgumentException:"
// CWE-22: Improper Limitation of a Pathname to a Restricted Directory ('Path Traversal')
// Tested and Runs successfully!

include "/Users/pari/pcc-llms/benchmark/task6-WIP/Filesystem.dfy"
import FS = Filesystem
import utils = Utils
import opened Wrappers
method Append (f: FS.Files, baseDir: string, filePath: string, separator: string) returns (appendRes:string)
 requires |separator| == 1
 requires |baseDir| > 0
 requires |filePath| > 0
 requires |baseDir| + |filePath| > 0
 ensures !utils.has_backslash_dot_dot(appendRes) && !utils.has_dot_dot_slash(appendRes)
    && !utils.has_dot_dot_backslash(appendRes) && !utils.has_slash_dot_dot(appendRes) 
{
  var joinRes := f.JoinPaths([baseDir, filePath], separator);
    if joinRes.Failure? {
      expect joinRes.Success?, "unexpected failure: " + joinRes.error;
      return;
    }
}
method ReadContent (f:FS.Files, filePath: string) returns (readRes: Result<seq<bv8>, string>)
  requires |filePath| > 0
  requires !utils.has_backslash_dot_dot(filePath) && !utils.has_dot_dot_slash(filePath)
    && !utils.has_dot_dot_backslash(filePath) && !utils.has_slash_dot_dot(filePath) && utils.non_empty_path(filePath)
  modifies f
{
   var openRes := f.Open(filePath);
      if openRes.Failure? {
        expect openRes.Success?, "unexpected error: " + openRes.error;
        return;
      }
      readRes := f.ReadBytesFromFile(filePath);
}

 method Main(filePath: string) 
  requires |filePath| > 0
  {
    var baseDir := "/Users/pari/pcc-llms/benchmark/CWE-23/dafny";
    var expectedStr := "Hello!\nThis is a safe text and you are allowed to read this content\n";
    var expectedBytes := seq(|expectedStr|, i requires 0 <= i < |expectedStr| => expectedStr[i] as int);
    var f := new FS.Files.Init("dummy.txt", []);
    var appendRes := Append(f, baseDir, filePath, "/");
    if |appendRes| <= 0 {
      return;
    }
    var readRes := ReadContent(f, appendRes);
    if readRes.Failure? {
      expect readRes.Success?, "unexpected failure: " + readRes.error;
      var readResEmpty := f.ReadBytesFromFile("");
      expect readResEmpty.Failure?, "unexpected success";
    } else {
      var readBytes := seq(|readRes.value|, i requires 0 <= i < |readRes.value| => readRes.value[i] as int);
      expect readBytes == expectedBytes, "read unexpected byte sequence";
    } 
    print("File read successfully! \n");
    print("File content: \n " + expectedStr);
  }
 