/*******************************************************************************
 *  Copyright by the contributors to the Dafny Project
 *  SPDX-License-Identifier: MIT
 *******************************************************************************/

// RUN: %verify "%s"
include "../std/Wrappers.dfy"
include "../std/utils/Utils.dfy"
include "../std/utils/AsciiConverter.dfy"
include "../std/utils/OsPath.dfy"

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
  datatype Error =  Noent | Exist
  datatype Ok<T> = Ok(v: T)
  datatype Permission = Read | Write | None

  class Files {
    var name: string
    var content: seq<char>
    var permission: Permission
    ghost var is_open:bool // Ghost variable can only be used in the specifications
    ghost var is_symbolic_link:bool
    ghost var size: nat
    // constructor Init(){
    //   is_open := false;
    //   is_symbolic_link := false;
    // }

    predicate valid()
    reads this
    {
      |name| > 0
    }
    
    constructor Init (name: string, perm: Permission)
      requires |name| > 0      // We can't create a file with an empty name
      ensures valid()
    {
      this.name := name;
      this.content := [];  // Empty file content initially
      this.permission := perm;
      this.is_open := false;
      this.is_symbolic_link := false;
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
      // requires is_open == false // If I use this precondition, I get an error when I use f.Open(filePath) in cwe-22-safe.dfy
      modifies this
      requires !Utils.has_dangerous_pattern(file)
      requires Utils.non_empty_path(file)
      ensures is_open == if res.Success? then true else false
    {
        var isError, fileStream, errorMsg := INTERNAL_Open(file);
        is_open := if isError then false else true;
        return if isError then Failure(errorMsg) else Success(fileStream);
      
    }

    method ReadBytesFromFile(file: string) returns (res: Result<seq<bv8>, string>) 
    requires permission == Read
    requires this.is_open == true
    {
      var isError, bytesRead, errorMsg := INTERNAL_ReadBytesFromFile(file);
      return if isError then Failure(errorMsg) else Success(bytesRead);
    }

    method WriteBytesToFile(file: string, bytes: seq<bv8>) returns (res: Result<(), string>)
    requires permission == Write
    requires this.is_open == true
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
    requires forall i:: 0 <= i < |paths| ==> |paths[i]| > 0
    ensures res.Success? ==> Utils.non_empty_path(res.value) && !Utils.has_dangerous_pattern(res.value)
    {
      if |paths| == 0 || |separator| == 0 {
        return Failure("Paths or separator cannot be empty.");
      }

      var combinedPath := "";
      var i := 0;
      while i < |paths|
      invariant 0 <= i <= |paths| 
      invariant |combinedPath| >= i  
      decreases |paths| - i 
      {
        combinedPath := combinedPath + paths[i] + separator; 
        i := i + 1;
      }

    if !Utils.non_empty_path(combinedPath) {
      return Failure("Resulting path is empty.");
    }
    if Utils.has_dangerous_pattern(combinedPath) {
      return Failure("Resulting path contains dangerous patterns.");
    }

      var isError, fullPath, errorMsg := INTERNAL_JoinPaths(paths, separator);
      if !isError {
        assert Utils.non_empty_path(fullPath);
        assert !Utils.has_dangerous_pattern(fullPath);
      }
      
      var notValidPath := if fullPath != combinedPath then false else true;
      return if (isError || notValidPath) then Failure(errorMsg) else Success(fullPath);
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
    INTERNAL_JoinPaths(paths: seq<string>, separator: string)
    returns (isError: bool, fullPath: string, errorMsg: string)
    ensures !isError ==> Utils.non_empty_path(fullPath) && !Utils.has_dangerous_pattern(fullPath)
}