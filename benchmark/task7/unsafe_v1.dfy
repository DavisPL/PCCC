// CWE-22: Improper Limitation of a Pathname to a Restricted Directory ('Path Traversal')
// dafny run --allow-warnings --unicode-char:false --target:cs absolute_path_to_dafny_file --input absolute_path_to_Filesystem.cs -- absolute_path_to_input_text_file "System.ArgumentException:"
// Using any input file with path traversal pattern cause an error

include "/Users/pari/pcc-llms/benchmark/task7/Filesystem.dfy"
import FS = Filesystem
import utils = Utils
import opened Wrappers
  method Main(args: seq<string>) 
  {
    expect |args| > 0;
    expect |args| == 4, "usage: " + args[0] + " FILE_PATH EXPECTED_ERROR_PREFIX";
    var filePath := args[1];
    var sensitivePath := args[2];
    var expectedErrorPrefix := args[3];
    var expectedStr := "This is a safe text and you are allowed to read this content";
    var expectedBytes := seq(|expectedStr|, i requires 0 <= i < |expectedStr| => expectedStr[i] as Utils.byte);
    expect |expectedBytes| > 0;
    expect |filePath| > 0;
    if filePath == "" {
      print("empty file path");
      return;
    }
    if |expectedBytes| == 0 {
      print("empty byte sequence");
      return;
    }
    var f := new FS.Files.Init(filePath, expectedBytes);
    print("file path: ", filePath);
    // {missing_specs}
    var openRes := f.Open(filePath, sensitivePath);
    expect openRes.Success?, "unexpected error: " + openRes.error;
    var readRes := f.ReadBytesFromFile(filePath);
    expect readRes.Success?, "unexpected failure: " + readRes.error;
    var readBytes := seq(|readRes.value|, i requires 0 <= i < |readRes.value| => readRes.value[i] as int);
    print("File read successfully! \n");
  }