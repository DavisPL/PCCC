
// dafny run --no-verify --unicode-char:false --target:cs ./ReadBytes.dfy --input ./FileIO.cs -- ./input.txt "System.ArgumentException:"
include "../../../stdlib/lib/FileIO.dfy"
import fs = FileIO
import utils = Utils

  method read_file(args: seq<string>) 
  {
    expect |args| > 0;
    expect |args| == 3, "usage: " + args[0] + " FILE_PATH EXPECTED_ERROR_PREFIX";
    var filePath := args[1];
    var expectedErrorPrefix := args[2];
    {
        var baseDir := "/Users/pari/pcc-llms/dataset/cwe-list/CWE-22";
        var f := new fs.Files.Init();
        var joinRes := f.JoinPaths([baseDir, filePath], "/");
        expect joinRes.Success?, "unexpected failure: " + joinRes.error;
        var jointPath := seq(|joinRes.value|, i requires 0 <= i < |joinRes.value| => joinRes.value[i] as char);
        
        var expectedStr := "Hello world\nGoodbye\n";
   
        var expectedBytes := seq(|expectedStr|, i requires 0 <= i < |expectedStr| => expectedStr[i] as int);
        if (utils.non_empty_path(jointPath) && utils.has_absolute_path(jointPath) && !utils.has_dangerous_pattern(jointPath)) {
          var res := f.Open(jointPath);
          if !res.Success? {
              jointPath := "";
              return;
          } else {
            var readRes := f.ReadBytesFromFile(jointPath);
            expect readRes.Success?, "unexpected failure: " + readRes.error;
            if readRes.Failure? {
                // Failure path: attempting to read from a blank file path should never work.
              var readRes := f.ReadBytesFromFile("");
              expect readRes.Failure?, "unexpected success";
              expect expectedErrorPrefix <= readRes.error, "unexpected error message: " + readRes.error;
            } else {
              var readBytes := seq(|readRes.value|, i requires 0 <= i < |readRes.value| => readRes.value[i] as int);
              expect readBytes == expectedBytes, "read unexpected byte sequence";
            }
      
          }
        }
    } 
  }