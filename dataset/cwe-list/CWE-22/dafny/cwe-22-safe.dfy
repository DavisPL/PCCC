
// dafny run --no-verify --unicode-char:false --target:cs ./ReadBytes.dfy --input ./FileIO.cs --input ./input.txt "System.ArgumentException:"
include "../../../../FilesystemsAPI/std/FileIO.dfy"
import fs = FileIO

  method Main(args: seq<string>) {
    expect |args| > 0;
    expect |args| == 3, "usage: " + args[0] + " FILE_PATH EXPECTED_ERROR_PREFIX";
    var filePath := args[1];
    var expectedErrorPrefix := args[2];

      // Happy path: read from the data file, and check that we see the expected content.
    {
        var baseDir := "/var/www/data/";
        var jointPath := fs.JoinPaths([baseDir, filePath], "/");
        
        var expectedStr := "Hello world\nGoodbye\n";
   
        var expectedBytes := seq(|expectedStr|, i requires 0 <= i < |expectedStr| => expectedStr[i] as int);

        var res := fs.ReadBytesFromFile(jointPath);
        expect res.Success?, "unexpected failure: " + res.error;

        var readBytes := seq(|res.value|, i requires 0 <= i < |res.value| => res.value[i] as int);
        expect readBytes == expectedBytes, "read unexpected byte sequence";
    }

      // Failure path: attempting to read from a blank file path should never work.
    {
      var res := fs.ReadBytesFromFile("");
      expect res.Failure?, "unexpected success";
      expect expectedErrorPrefix <= res.error, "unexpected error message: " + res.error;
    }
  }