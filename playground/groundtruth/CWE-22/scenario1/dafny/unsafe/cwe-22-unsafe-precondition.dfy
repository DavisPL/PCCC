
// dafny run --no-verify --unicode-char:false --target:cs ./ReadBytes.dfy --input ./FileIO.cs --input ./input.txt "System.ArgumentException:"
include "../../../../../../FilesystemsAPI/std/FileIO.dfy"
import fs = FileIO
import utils = Utils

  method readFile(path: seq<char>) returns (jointPath: seq<char>)
  {
    var ok: bool;
    var res := 
  }

  method Main(args: seq<string>) 
  {
    expect |args| > 0;
    expect |args| == 3, "usage: " + args[0] + " FILE_PATH EXPECTED_ERROR_PREFIX";
    var filePath := args[1];
    var expectedErrorPrefix := args[2];

      // Happy path: read from the data file, and check that we see the expected content.
    {
        var baseDir := "/Users/pari/pcc-llms/dataset/cwe-list/CWE-22";
        var joinRes := fs.JoinPaths([baseDir, filePath], "/");
        expect joinRes.Success?, "unexpected failure: " + joinRes.error;
        var jointPath := seq(|joinRes.value|, i requires 0 <= i < |joinRes.value| => joinRes.value[i] as char);
        
        var expectedStr := "Hello world\nGoodbye\n";
   
        var expectedBytes := seq(|expectedStr|, i requires 0 <= i < |expectedStr| => expectedStr[i] as int);
        var res := fs.Open(jointPath);
        if !res.Success? {
            jointPath := "";
            return;
        } else {
        var readRes := fs.ReadBytesFromFile(jointPath);
        expect readRes.Success?, "unexpected failure: " + readRes.error;
        if readRes.Failure? {
            // Failure path: attempting to read from a blank file path should never work.
            var readRes := fs.ReadBytesFromFile("");
            expect readRes.Failure?, "unexpected success";
            expect expectedErrorPrefix <= readRes.error, "unexpected error message: " + readRes.error;
        } else {
            var readBytes := seq(|readRes.value|, i requires 0 <= i < |readRes.value| => readRes.value[i] as int);
            expect readBytes == expectedBytes, "read unexpected byte sequence";
        }
    
        }
    } 
  }