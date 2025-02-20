
// CWE-22: Improper Limitation of a Pathname to a Restricted Directory ('Path Traversal')
// dafny run --allow-warnings --unicode-char:false --target:cs absolute_path_to_dafny_file --input absolute_path_to_Filesystem.cs -- absolute_path_to_input_text_file "System.ArgumentException:"
// Using any input file with path traversal pattern cause an error

include "/Users/pari/pcc-llms/benchmark/Task1/Filesystem.dfy"
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
     expect |expectedBytes| > 0, "empty byte sequence";
    expect |filePath| > 0, "empty file path";
    var f := new FS.Files.Init(filePath, expectedBytes);
    print("file path: ", filePath);
    // {missing_specs}
    var openRes := f.Open(filePath);
    expect openRes.Success?, "unexpected error: " + openRes.error;
    var readRes := f.ReadBytesFromFile(filePath);
    expect readRes.Success?, "unexpected failure: " + readRes.error;
    var readBytes := seq(|readRes.value|, i requires 0 <= i < |readRes.value| => readRes.value[i] as Utils.byte);
    expect readBytes == expectedBytes, "read unexpected byte sequence";
    print("File read successfully! \n");
    print("File content: \n " + expectedStr);
  }