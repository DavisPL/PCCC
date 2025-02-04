/*******************************************************************************
 *  Copyright by the contributors to the Dafny Project
 *  SPDX-License-Identifier: MIT
 *******************************************************************************/

// RUN: %verify "%s"

// #RUN: %run --no-verify --unicode-char:false --target:cs "%s" --input "%S/../../src/FileIO/FileIO.cs" -- "%S/data.txt" "System.ArgumentException:"
// #RUN: %run --no-verify --unicode-char:false --target:java "%s" --input "%S/../../src/FileIO/FileIO.java" -- "%S/data.txt" "java.io.IOException:"
// #RUN: %run --no-verify --unicode-char:false --target:js "%s" --input "%S/../../src/FileIO/FileIO.js" -- "%S/data.txt" "Error: ENOENT"
// dafny run /Users/pari/pcc-llms/FilesystemsAPI/std/tests/read/ReadBytes.dfy --no-verify --unicode-char:false --target:cs --input /Users/pari/pcc-llms/FilesystemsAPI/std/FileIO.cs -- /Users/pari/pcc-llms/FilesystemsAPI/std/tests/read/data.txt "System.ArgumentException:"
// dafny run ./ReadBytes.dfy --allow-warnings --no-verify --unicode-char:false --target:cs --input ../../FileIO.cs -- ./data.txt "System.ArgumentException:"
include "/Users/pari/pcc-llms/stdlib/Filesystem.dfy"

module ReadBytesFromFile {
  import FS = Filesystem

  method Main(args: seq<string>) {
    expect |args| > 0;
    expect |args| == 3, "usage: " + args[0] + " DATA_PATH EXPECTED_ERROR_PREFIX";
    var dataPath := args[1];
    var expectedErrorPrefix := args[2];

      // Happy path: read from the data file, and check that we see the expected content.
    {
      var expectedStr := "Hello world\nGoodbye\n";
      // This conversion is safe only for ASCII values. For Unicode conversions, see the Unicode modules.
      var expectedBytes := seq(|expectedStr|, i requires 0 <= i < |expectedStr| => expectedStr[i] as int);
      var f := new FS.Files.Init("dummy.txt", []);
      var res := f.ReadBytesFromFile(dataPath);
      expect res.Success?, "unexpected failure: " + res.error;

      var readBytes := seq(|res.value|, i requires 0 <= i < |res.value| => res.value[i] as int);
      expect readBytes == expectedBytes, "read unexpected byte sequence";
    }

      // Failure path: attempting to read from a blank file path should never work.
    {
      var res := f.ReadBytesFromFile("");
      expect res.Failure?, "unexpected success";
      expect expectedErrorPrefix <= res.error, "unexpected error message: " + res.error;
    }
  }
}