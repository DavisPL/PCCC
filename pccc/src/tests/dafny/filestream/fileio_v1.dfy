
newtype{:nativeType "byte"} byte = i:int | 0 <= i < 0x100
newtype{:nativeType "int"} int32 = i:int | -0x80000000 <= i < 0x80000000
newtype{:nativeType "int"} nat32 = i:int | 0 <= i < 0x80000000

class OkState
  {
  constructor{:extern} () requires false
  function{:extern} ok():bool reads this
}

class HostEnvironment
  {
  constructor{:extern} () requires false
  ghost var ok:OkState
}



class FileStream
  {
  ghost var env:HostEnvironment
  function{:extern} Name():string reads this
  function{:extern} IsOpen():bool reads this
  constructor{:extern} () requires false

  static method{:extern} Open(name:array<char>, ghost env:HostEnvironment)
    returns(ok:bool, f:FileStream)
    requires name[..] in ["file.txt", "foo.txt"]
    requires env.ok.ok()
    modifies env.ok
    ensures  env.ok.ok() == ok
    ensures  ok ==> fresh(f) && f.env == env && f.IsOpen() && f.Name() == name[..]

  method{:extern} Close() returns(ok:bool)
    requires env.ok.ok()
    requires IsOpen()
    modifies this
    modifies env.ok
    ensures  env == old(env)
    ensures  env.ok.ok() == ok

  method{:extern} Read(fileOffset:nat32, buffer:array<byte>, start:int32, end:int32) returns(ok:bool)
    requires env.ok.ok()
    requires IsOpen()
    requires 0 <= start as int <= end as int <= buffer.Length
    requires Name() in ["file.txt", "foo.txt"] 
    // add here ___INSERT_PRECONDITION_CLOSE___
    modifies env.ok
    modifies buffer
    ensures  env == old(env)
    ensures  env.ok.ok() == ok
    ensures  Name() == old(Name())
    ensures  forall i:int :: 0 <= i < buffer.Length && !(start as int <= i < end as int) ==> buffer[i] == old(buffer[i])
    ensures  ok ==> IsOpen()

  method{:extern} Write(fileOffset:nat32, buffer:array<byte>, start:int32, end:int32) returns(ok:bool)
    requires env.ok.ok()
    requires IsOpen()
    requires 0 <= start as int <= end as int <= buffer.Length
    requires Name() in ["file.txt", "foo.txt"]
    modifies this
    modifies env.ok
    ensures  env == old(env)
    ensures  env.ok.ok() == ok
    ensures  Name() == old(Name())
    ensures  ok ==> IsOpen()

  method{:extern} Flush() returns(ok:bool)
    requires env.ok.ok()
    requires IsOpen()
    requires Name() in ["file.txt", "foo.txt"]
    modifies this
    modifies env.ok
    ensures  env == old(env)
    ensures  env.ok.ok() == ok
    ensures  Name() == old(Name())
    ensures  ok ==> IsOpen()

  // method{:axiom} Join(cwd: array<char>, filename: array<char>) returns (ok:bool)
  //   requires env.ok.ok()
  //   requires IsOpen()
  //   requires Name() in ["file.txt", "foo.txt"]
  //   requires cwd != null && filename != null
  //   modifies this
  //   ensures  env == old(env)
  //   ensures  env.ok.ok() == old(env.ok.ok())
  //   ensures  Name() == old(Name())
  //   ensures  result == os_path_join(cwd, filename)
  //   ensures  old(env.ok.ok()) ==> IsOpen()

  // function os_path_join(cwd: array<char>, filename: array<char>) : seq<char>
  //     ensures result == cwd + [PathSeparator] + filename
}
