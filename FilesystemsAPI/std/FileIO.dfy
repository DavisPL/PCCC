/*******************************************************************************
 *  Copyright by the contributors to the Dafny Project
 *  SPDX-License-Identifier: MIT
 *******************************************************************************/

// RUN: %verify "%s"

include "./Wrappers.dfy"
include "./Utils.dfy"

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
module {:options "-functionSyntax:4"} FileIO {
  import opened Wrappers
  import Utils
  // export provides ReadBytesFromFile, WriteBytesToFile, Wrappers, IsLink, Open, Utils
  export provides ReadBytesFromFile, WriteBytesToFile, Wrappers, IsLink, Open, Utils, JoinPaths
  datatype Error =  Noent | Exist
  datatype Ok<T> = Ok(v: T)


   /**
    * Opens a file at the given path.
    * Checks if the file exists and resolves its absolute path.
    * Returns a `Result` containing a `FileHandle` on success or an error message on failure.
    *
    * NOTE: See the module description for limitations on the path argument.
    */
  method Open(path: string) returns (res: Result<object, string>)
  // requires path != "" && |path| > 0
    requires !Utils.has_dangerous_pattern(path)
    requires Utils.non_empty_path(path)
  {
      var isError, fileStream, errorMsg := INTERNAL_Open(path);
      return if isError then Failure(errorMsg) else Success(fileStream);
  }

  /*
   * Public API
   */

  /**
    * Attempts to read all bytes from the file at the given file path.
    * If an error occurs, a `Result.Failure` value is returned containing an implementation-specific
    * error message (which may also contain a stack trace).
    *
    * NOTE: See the module description for limitations on the path argument.
    */
  method ReadBytesFromFile(path: string) returns (res: Result<seq<bv8>, string>) {
    var isError, bytesRead, errorMsg := INTERNAL_ReadBytesFromFile(path);
    return if isError then Failure(errorMsg) else Success(bytesRead);
  }

  /**
    * Attempts to write the given bytes to the file at the given file path,
    * creating nonexistent parent directories as necessary.
    * If an error occurs, a `Result.Failure` value is returned containing an implementation-specific
    * error message (which may also contain a stack trace).
    *
    * NOTE: See the module description for limitations on the path argument.
    */
  method WriteBytesToFile(path: string, bytes: seq<bv8>) returns (res: Result<(), string>)
  {
    var isError, errorMsg := INTERNAL_WriteBytesToFile(path, bytes);
    return if isError then Failure(errorMsg) else Success(());
  }


  method IsLink(path: string) returns (res: Result<bool, string>) 
  {
    var isError, isLink, errorMsg := INTERNAL_IsLink(path);
    if isError {
      res := Failure(errorMsg);
    } else {
      res := Success(isLink);
    }
  }


  method JoinPaths(paths: seq<string>, separator: string) returns (res: Result<string, string>) {
    var isError, fullPath, errorMsg := INTERNAL_JoinPaths(paths, separator);
    return if isError then Failure(errorMsg) else Success(fullPath);
  }
  

  // method isFile(path: string) returns (res: Result<bool, string>) {
  //   var isFile, errorMsg := INTERNAL_IsFile(path);
  //   return if isFile then Failure(errorMsg) else Success(isFile);
  // }
  // method NormalizePath(paths: seq<string>)


  /*
   * Private API - these are intentionally not exported from the module and should not be used elsewhere
  */
  method
    {:extern "DafnyLibraries.FileIO", "INTERNAL_Open"}
  INTERNAL_Open(path: string)
    returns (isError: bool, fs: object, errorMsg: string)
    requires !Utils.has_dangerous_pattern(path)
    requires Utils.non_empty_path(path)


  method
    {:extern "DafnyLibraries.FileIO", "INTERNAL_ReadBytesFromFile"}
  INTERNAL_ReadBytesFromFile(path: string)
    returns (isError: bool, bytesRead: seq<bv8>, errorMsg: string)

  method
    {:extern "DafnyLibraries.FileIO", "INTERNAL_WriteBytesToFile"}
  INTERNAL_WriteBytesToFile(path: string, bytes: seq<bv8>)
    returns (isError: bool, errorMsg: string)

  method
  {:extern "DafnyLibraries.FileIO", "INTERNAL_IsLink"}
  INTERNAL_IsLink(path: string)
  returns ( isError: bool, isLink: bool, errorMsg: string)

  method
    {:extern "DafnyLibraries.FileIO", "INTERNAL_JoinPaths"}
  INTERNAL_JoinPaths(paths: seq<string>, separator: string)
  returns (isError: bool, fullPath: string, errorMsg: string)

}