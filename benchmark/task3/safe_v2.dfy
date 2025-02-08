
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
      expect |args| > 0;
      expect |args| == 4, "usage: " + args[0] + " FILE_PATH CONTENT EXPECTED_ERROR_PREFIX";
      var filePath := args[1];
      var contentStr := args[2];
      var expectedErrorPrefix := args[3];

      var baseDir := "/Users/pari/pcc-llms/benchmark/task3";
      var f := new FS.Files.Init("dummy.txt", []);
      var joinRes := f.JoinPaths([baseDir, filePath], "/");
      if joinRes.Failure? {
        expect joinRes.Success?, "unexpected failure: " + joinRes.error;
        return;
      }
      if !(utils.non_empty_string(contentStr) && utils.is_valid_content_str(contentStr)) {
        print ("Invalid content string or empty string!");
        return;
      }
        var jointPath := seq(|joinRes.value|, i requires 0 <= i < |joinRes.value| => joinRes.value[i] as char); 
        var bytes :seq<bv8> := strConverter.strToBytes(contentStr);
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