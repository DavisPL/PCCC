
// CWE-22: Improper Limitation of a Pathname to a Restricted Directory ('Path Traversal')
// dafny run --allow-warnings --unicode-char:false --target:cs absolute_path_to_dafny_file --input absolute_path_to_Filesystem.cs -- absolute_path_to_input_text_file "System.ArgumentException:"
// Using any input file with path traversal pattern cause an error

include "/Users/pari/pcc-llms/benchmark/task1/Filesystem.dfy"
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
    var expectedStr := "This is a safe text and you are allowed to read this content";
    var expectedBytes := seq(|expectedStr|, i requires 0 <= i < |expectedStr| => expectedStr[i] as Utils.byte);
    if |filePath| == 0{
      print("empty file path");
      return;
    }
    if |expectedBytes| == 0 {
      print("empty byte sequence");
      return;
    }
    var f := new FS.Files.Init(filePath, expectedBytes);
    print("file path: ", filePath);
    if(!utils.has_dangerous_pattern(filePath) && utils.non_empty_path(filePath)){
      var openRes := f.Open(filePath);
      if openRes.Failure? {
        print("unexpected error: ", openRes.error);
        return;
      }
      var readRes := f.ReadBytesFromFile(filePath);
      if readRes.Failure? {
        print("unexpected failure: ", readRes.error);
        return;
      }
      var readBytes := seq(|readRes.value|, i requires 0 <= i < |readRes.value| => readRes.value[i] as Utils.byte);
      if readBytes != expectedBytes {
        print("read unexpected byte sequence");
        return;
      } 
      print("File read successfully! \n");
      print("File content: \n " + expectedStr);
    } else {
      print("Unsafe or empty file path");
      return;
    }
  }