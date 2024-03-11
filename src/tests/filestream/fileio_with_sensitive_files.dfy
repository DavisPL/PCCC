
newtype{:nativeType "byte"} byte = i:int | 0 <= i < 0x100
newtype{:nativeType "int"} int32 = i:int | -0x80000000 <= i < 0x80000000
newtype{:nativeType "int"} nat32 = i:int | 0 <= i < 0x80000000

class OkState
  {
  constructor{:axiom} () requires false
  function{:axiom} ok():bool reads this
}

class HostEnvironment
  {
  constructor{:axiom} () requires false
  ghost var ok:OkState
}



class FileStream
  {
  ghost var env:HostEnvironment
  function{:axiom} Name():string reads this
  function{:axiom} IsOpen():bool reads this
  function{:axiom} Access():string reads this
  function {:axiom} Capabilities():(string, string) reads this
  constructor{:axiom} () requires false

  // static method{:axiom} Open(name:array<char>, ghost env:HostEnvironment, access:array<char>)
    static method{:axiom} Open(name:array<char>, ghost env:HostEnvironment)
    returns(ok:bool, f:FileStream)
    // CannotAccessSensitiveFiles(l: ["bar.txt", "baz.txt"], access: ["bar.txt", "baz.txt"])
    requires name[..] in ["bar.txt", "baz.txt"]
    // requires access[..] in ["read", "write"]
    // requires capabilities in [("bar.txt", "write")]
    requires env.ok.ok()
    modifies env.ok
    ensures  env.ok.ok() == ok
    ensures  ok ==> fresh(f) && f.env == env && f.IsOpen() && f.Name() == name[..]

  method{:axiom} Close() returns(ok:bool)
    requires Name() in ["bar.txt", "baz.txt"]
    // requires Access() in ["read", "write"]
    // requires Capabilities in [("bar.txt", ["read, write"]), ("baz.txt", ["read"])]
    requires env.ok.ok()
    requires IsOpen()
    modifies this
    modifies env.ok
    ensures  env == old(env)
    ensures  env.ok.ok() == ok

  method{:axiom} Read(fileOffset:nat32, buffer:array<byte>, start:int32, end:int32) returns(ok:bool)
    requires env.ok.ok()
    requires IsOpen()
    requires 0 <= start as int <= end as int <= buffer.Length
    requires Name() in ["bar.txt", "baz.txt"]
    // requires Access() in ["read", "write"]
    // requires Capabilities() in [("bar.txt", ["read, write"]), ("baz.txt", ["read"])]
    modifies env.ok
    modifies buffer
    ensures  env == old(env)
    ensures  env.ok.ok() == ok
    ensures  Name() == old(Name())
    ensures  forall i:int :: 0 <= i < buffer.Length && !(start as int <= i < end as int) ==> buffer[i] == old(buffer[i])
    ensures  ok ==> IsOpen()

  method{:axiom} Write(fileOffset:nat32, buffer:array<byte>, start:int32, end:int32) returns(ok:bool)
    requires env.ok.ok()
    requires IsOpen()
    requires 0 <= start as int <= end as int <= buffer.Length
    requires Name() in ["bar.txt", "baz.txt"]
    // requires Access() in ["read", "write"]
    // requires Capabilities in [("bar.txt", ["read, write"]), ("baz.txt", ["read"])]
    modifies this
    modifies env.ok
    ensures  env == old(env)
    ensures  env.ok.ok() == ok
    ensures  Name() == old(Name())
    ensures  ok ==> IsOpen()

  method{:axiom} Flush() returns(ok:bool)
    requires env.ok.ok()
    requires IsOpen()
    modifies this
    modifies env.ok
    ensures  env == old(env)
    ensures  env.ok.ok() == ok
    ensures  Name() == old(Name())
    ensures  ok ==> IsOpen()

  method{:axiom} Join(path:seq<char>, file:seq<char>) returns(ok:bool, result:seq<char>)
  // requires path1[..] in ["bar.txt", "baz.txt"]
  // requires file[..] in ["foo.txt", "foobar.txt"]
  requires env.ok.ok()
  requires forall i :: 0 <= i < |path| ==> !(((i < |path| - 1 && ((path[i] == '.' && path[i + 1] == '.') || (path[i] == '/' && path[i + 1] == '/'))) || (i < |path| - 2 && path[i] == '.' && path[i + 1] == '.' && path[i + 2] == '/')))
  requires forall i :: 0 <= i < |file| ==> !(((i < |file| - 1 && ((file[i] == '.' && file[i + 1] == '.') || (file[i] == '/' && file[i + 1] == '/'))) || (i < |file| - 2 && file[i] == '.' && file[i + 1] == '.' && file[i + 2] == '/')))
  requires IsOpen()
  modifies this
  modifies env.ok
  ensures  env == old(env)
  ensures  env.ok.ok() == ok
  ensures forall i :: 0 <= i < |result| ==> !(((i < |result| - 1 && ((result[i] == '.' && result[i + 1] == '.') || (result[i] == '/' && result[i + 1] == '/'))) || (i < |result| - 2 && result[i] == '.' && result[i + 1] == '.' && result[i + 2] == '/')))
  ensures |result| <= |path| + |file|

  // method{:axiom} IsFileNameValid (filename: seq<char>)
}
