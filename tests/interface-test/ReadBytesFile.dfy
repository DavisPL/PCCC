/*******************************************************************************
 *  Copyright by the contributors to the Dafny Project
 *  SPDX-License-Identifier: MIT
 *******************************************************************************/
 // ToDo: modify this to work with the FileIO.dfy and dafny test command
include "../../std/Filesystem.dfy"
module ReadBytesFromFile {
  import Filesystem

  method {:test} Test() {
    // TODO: extern function for the expected error prefix
    theMain("/Users/pari/pcc-llms/FilesystemsAPI/StandardFileIO/input.txt", "");
  }

  method theMain(dataPath: string, expectedErrorPrefix: string) {

      // Happy path: read from the data file, and check that we see the expected content.
    {
      var expectedStr := "Hello world";
      // This conversion is safe only for ASCII values. For Unicode conversions, see the Unicode modules.
      var expectedBytes := seq(|expectedStr|, i requires 0 <= i < |expectedStr| => expectedStr[i] as int);

      var res := Filesystem.ReadBytesFromFile(dataPath);
      expect res.Success?, "unexpected failure: " + res.error;

      var readBytes := seq(|res.value|, i requires 0 <= i < |res.value| => res.value[i] as int);
      expect readBytes == expectedBytes, "read unexpected byte sequence";
    }

      // Failure path: attempting to read from a blank file path should never work.
    {
      var res := Filesystem.ReadBytesFromFile("");
      expect res.Failure?, "unexpected success";
      expect expectedErrorPrefix <= res.error, "unexpected error message: " + res.error;
    }
  }
}