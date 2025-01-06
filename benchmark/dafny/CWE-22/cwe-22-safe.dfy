
// dafny run --no-verify --unicode-char:false --target:cs ./ReadBytes.dfy --input ./FileIO.cs -- ./input.txt "System.ArgumentException:"
include "/Users/pari/pcc-llms/stdlib/lib/FileIO.dfy"
import FIO = FileIO
import utils = Utils
  method Main(args: seq<string>) 
  {
    expect |args| > 0;
    expect |args| == 3, "usage: " + args[0] + " FILE_PATH EXPECTED_ERROR_PREFIX";
    var filePath := args[1];
    var expectedErrorPrefix := args[2];

        var baseDir := "/Users/pari/pcc-llms/benchmark/dafny/CWE-22/";
        var f := new FIO.Files.Init();
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
              var readRes2 := f.ReadBytesFromFile("");
              expect readRes2.Failure?, "unexpected success";
              expect expectedErrorPrefix <= readRes2.error, "unexpected error message: " + readRes2.error;
            } else {
              var readBytes := seq(|readRes.value|, i requires 0 <= i < |readRes.value| => readRes.value[i] as int);
              expect readBytes == expectedBytes, "read unexpected byte sequence";
            }
      
          }
        }
      // expect filePath == "/Users/pari/pcc-llms/benchmark/dafny/CWE-22/input.txt", "unexpected file path";
        // Happy path: read from the data file, and check that we see the expected content.
      // {
      //   var expectedStr := "Hello world";
      //   // This conversion is safe only for ASCII values. For Unicode conversions, see the Unicode modules.
      //   var expectedBytes := seq(|expectedStr|, i requires 0 <= i < |expectedStr| => expectedStr[i] as int);

      //   var res := f.ReadBytesFromFile(filePath);
      //   expect res.Success?, "unexpected failure: " + res.error;

      //   var readBytes := seq(|res.value|, i requires 0 <= i < |res.value| => res.value[i] as int);
      //   expect readBytes == expectedBytes, "read unexpected byte sequence";
      // }

      //   // Failure path: attempting to read from a blank file path should never work.
      // {
      //   var res := f.ReadBytesFromFile("");
      //   expect res.Failure?, "unexpected success";
      //   expect expectedErrorPrefix <= res.error, "unexpected error message: " + res.error;
      // }

  }
// }