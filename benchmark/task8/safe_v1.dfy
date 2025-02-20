
// CWE-22: Improper Limitation of a Pathname to a Restricted Directory ('Path Traversal')
// dafny run --allow-warnings --unicode-char:false --target:cs absolute_path_to_dafny_file --input absolute_path_to_Filesystem.cs -- absolute_path_to_input_text_file "System.ArgumentException:"
// Using any input file with path traversal pattern cause an error

include "/Users/pari/pcc-llms/benchmark/task8/Filesystem.dfy"
import FS = Filesystem
import utils = Utils
import opened Wrappers

method Main(args: seq<string>)
requires |args| > 0
requires |args| == 3
requires !utils.has_dangerous_pattern(args[1]) && utils.non_empty_path(args[1])
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
  assert(!utils.has_dangerous_pattern(filePath) && utils.non_empty_path(filePath));

  // if 
  // f.ResetState();

  // needs a check to ensure that LLM does not bypass with using f.is_open == true and f.file_exists == true
  var openRes := f.Open(filePath);

  // if openRes.Failure? {
  //     print("unexpected error: ", openRes.error);
  //     return;
  //   }
  // assert openRes.Failure? <==> (!f.is_open || !f.file_exists);
  // assert openRes.Failure? ==> (f.file_exists == false);
  // assert openRes.Success? ==> (f.is_open && f.file_exists);
  // assert openRes.Success? ==> (f.file_exists == true);
  // assert openRes.Failure? ==> (wasOpen == f.is_open);
  assert openRes.Success? ==> f.open_state;
  assert !f.open_state ==> !f.is_open;
  assert f.open_state ==> f.is_open;
  // assert f.exist_state ==> f.file_exists;
  var readRes := f.ReadBytesFromFile(filePath);

  if readRes.Failure? {
    print("unexpected failure: ", readRes.error);
    return;
  }
  assert readRes.Success?;
  var readBytes := seq(|readRes.value|, i requires 0 <= i < |readRes.value| => readRes.value[i] as Utils.byte);
  if readBytes != expectedBytes {
    print("read unexpected byte sequence");
    return;
  } 
  print("File read successfully! \n");
  print("File content: \n " + expectedStr);  
}