/*******************************************************************************
 *  Copyright by the contributors to the Dafny Project
 *  SPDX-License-Identifier: MIT
 *******************************************************************************/

// RUN: %verify "%s"
include "../../std/Wrappers.dfy"
include "../../std/utils/Utils.dfy"
include "../../std/utils/AsciiConverter.dfy"

/**
  * This module provides basic file I/O operations: reading and writing bytes from/to a file.
  * The provided API is intentionally limited in scope and will be expanded later.
  *
  * Where the API accepts file paths as strings, there are some limitations.
  * File paths containing only ASCII characters work identically across languages and platforms;
  * non-ASCII Unicode codepoints may cause different language- or platform-specific behavior.
  *
  * File path symbols including . and .. are allowed.
  */
module {:options "-functionSyntax:4"} Filesystem {
  import opened Wrappers
  import Utils
  import AsciiConverter
  datatype Access = Read | Write | Execute | None
  datatype FileContentFormat = json | xml | csv | txt | binary | unknown
  class Files {
    var name: string
    var content: seq<char>
    ghost var is_open:bool // Ghost variable can only be used in the specifications
    ghost var is_symbolic_link:bool
    ghost var size: nat
    ghost var access: Access
    ghost var format: FileContentFormat
    
    constructor Init (name: string:= "new_file.txt")
      requires |name| > 0      // We can't create a file with an empty name
    {
      this.name := name;
      this.access := Access.None;
      this.content := [];  // Empty file content initially
      this.is_open := false;
      this.is_symbolic_link := false;
      this.format := FileContentFormat.unknown;
    }

     /**
    * Opens a file at the given path.
    * Checks if the file exists and resolves its absolute path.
    * Returns a `Result` containing a `FileHandle` on success or an error message on failure.
    *
    * NOTE: See the module description for limitations on the path argument.
    */

    // method fileExists(file: string) returns (res: Result<bool, string>)
    // {
    //   var isError, fileExists, errorMsg := INTERNAL_fileExists(file);
    //   return if isError then Failure(errorMsg) else Success(fileExists);
    // }
 
    method Open(file: string) returns (res: Result<object, string>)
      modifies this
      requires |file| > 4
      requires Utils.extract_file_type(file[|file|-4..], ".txt")
      ensures res.Success? ==> is_open
      ensures res.Success? ==> access == Access.Read
      ensures res.Success? ==> format == FileContentFormat.txt
    {
      var isError, fileStream, errorMsg := INTERNAL_Open(file);
      is_open := !isError;
      this.access := if is_open then Access.Read else Access.None;
      this.format := if is_open then FileContentFormat.txt else FileContentFormat.unknown;
      return if (isError) then Failure(errorMsg) else Success(fileStream);
    }

    method ReadBytesFromFile(file: string) returns (res: Result<seq<bv8>, string>) 
    ensures res.Success? ==> forall i:: 0 <= i < |res.value| ==> 0 <= res.value[i] < 255
    {
      var isError, bytesRead, errorMsg := INTERNAL_ReadBytesFromFile(file);
      var invalidByte := false;
      if !isError {
        var i := 0;
        while i < |bytesRead|
          invariant 0 <= i <= |bytesRead|
          invariant forall j:: 0 <= j < i ==> 0 <= bytesRead[j] < 255
          {
            if !(0 <= bytesRead[i] < 255) {
              invalidByte := true;
              break;
            }
            i := i + 1;
          }
      }
      return if isError || invalidByte then Failure(errorMsg) else Success(bytesRead);
    }

    method WriteBytesToFile(file: string, bytes: seq<bv8>) returns (res: Result<(), string>)
    {
      var isError, errorMsg := INTERNAL_WriteBytesToFile(file, bytes);
      return if isError then Failure(errorMsg) else Success(());
    }


    method IsLink(file: string) returns (res: Result<bool, string>) 
    {
      var isError, isLink, errorMsg := INTERNAL_IsLink(file);
      if isError {
        res := Failure(errorMsg);
      } else {
        res := Success(isLink);
      }
    }

    method Join(paths: seq<string>, separator: string) returns (res: Result<string, string>) 
    requires |separator| == 1
    requires |paths| > 0
    ensures res.Success? ==> Utils.non_empty_path(res.value) && !Utils.has_dangerous_pattern(res.value)
    {
      if |paths| == 0 || |separator| == 0 {
        return Failure("Paths or separator cannot be empty.");
      }
      var isError, fullPath, errorMsg := INTERNAL_Join(paths, separator);
      return if (isError) then Failure(errorMsg) else Success(fullPath);
    }

    method ReadAndSanitizeFileContent(file: string) returns (content: seq<char>)
    requires this.is_open && this.access == Access.Read
    {
        var bytesContent:= [];
        var isError, bytesRead, errorMsg := INTERNAL_ReadBytesFromFile(file);
        if isError {
            print "unexpected failure: " + errorMsg;
            return [];
        }
        bytesContent := seq(|bytesRead|, i requires 0 <= i < |bytesRead| => bytesRead[i]);
        content := AsciiConverter.ByteToString(bytesContent);
        if |content| < 8 {
            return [];
        } 
        var unsanitized := Utils.SanitizeFileContent(content);
        print "Unsanitized: ", unsanitized;
        if unsanitized {
            return [];
        }
    }

    method validateFileContent(file: string) returns (isValid: bool, content: seq<char>)
    requires this.is_open && this.access == Access.Read
    ensures isValid <==> (|content| > 0 && forall i:: 0 <= i < |content| ==> Utils.is_valid_content_char(content[i])) 
    {
        content := [];
        isValid := false;
        var bytesContent:= [];
        var isError, bytesRead, errorMsg := INTERNAL_ReadBytesFromFile(file);
        if isError {
            print "unexpected failure: " + errorMsg;
            return isValid, [];
        }
        bytesContent := seq(|bytesRead|, i requires 0 <= i < |bytesRead| => bytesRead[i]);
        var strContent := AsciiConverter.ByteToString(bytesContent);
        if |strContent| < 1 {
          isValid := false;
          return isValid, [];
        }
        var i:=0;
        while i < |strContent|
          invariant 0 <= i <= |strContent|
          invariant forall j:: 0 <= j < i ==> Utils.is_valid_content_char(strContent[j])
          {
            if !Utils.is_valid_content_char(strContent[i]) {
              isValid := false;
              return isValid, [];
            }
            i := i + 1;
          }
        content := strContent;
        isValid := true;
        return isValid, content;
    }


  }

    method
      {:extern "Filesystem.Files", "INTERNAL_Open"}
    INTERNAL_Open(file: string)
    returns (isError: bool, fs: object, errorMsg: string)


    method
      {:extern "Filesystem.Files", "INTERNAL_ReadBytesFromFile"}
    INTERNAL_ReadBytesFromFile(file: string)
      returns (isError: bool, bytesRead: seq<bv8>, errorMsg: string)

    method
      {:extern "Filesystem.Files", "INTERNAL_WriteBytesToFile"}
    INTERNAL_WriteBytesToFile(file: string, bytes: seq<bv8>)
      returns (isError: bool, errorMsg: string)

    method
    {:extern "Filesystem.Files", "INTERNAL_IsLink"}
    INTERNAL_IsLink(file: string)
    returns ( isError: bool, isLink: bool, errorMsg: string)

    method
      {:extern "Filesystem.Files", "INTERNAL_Join"}
    INTERNAL_Join(paths: seq<string>, separator: string)
    returns (isError: bool, fullPath: string, errorMsg: string)
    ensures !isError ==> Utils.non_empty_path(fullPath) && !Utils.has_dangerous_pattern(fullPath)

}