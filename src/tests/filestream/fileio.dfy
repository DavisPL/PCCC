
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

// class FileSet {
//   var fileNames: set<array<char>>

//   constructor() {
//     fileNames := {};
//   }


//   method AddFile(fileName: array<char>)
//     modifies this
//     requires fileName.Length > 0
//     // requires !FileNameContainsInvalidChars(fileName)
//     requires !(fileName in fileNames)
//     ensures fileName in fileNames
//   {
//     fileNames := fileNames + {fileName};
//   }

//   method ModifyFileName(oldFileName: array<char>, newFileName: array<char>)
//     modifies this
//     requires oldFileName.Length > 0 && newFileName.Length > 0
//     requires oldFileName in fileNames
//     requires !(newFileName in fileNames)
//     // requires FileNameContainsInvalidChars(newFileName)
//     requires newFileName.Length > 0
//   {
//     fileNames := fileNames - {oldFileName} + {newFileName};
//   }

//   method EnsureUniqueFileList(originalList: seq<array<char>>) returns (uniqueList: seq<array<char>>)
//     ensures forall j, k :: 0 <= j && j < k && k < |uniqueList| ==> uniqueList[j] != uniqueList[k]
//     ensures forall m :: m in uniqueList ==> m in originalList
//     ensures forall n :: n in originalList ==> n in uniqueList || (exists i :: i in originalList && i == n)
//   {
//     uniqueList := [];
//     var i := 0;
//     while i < |originalList|
//       decreases |originalList| - i
//       invariant 0 <= i && i <= |originalList|
//       invariant forall j, k :: 0 <= j && j < k && k < |uniqueList| ==> uniqueList[j] != uniqueList[k]
//       invariant forall m :: 0 <= m && m < |uniqueList| ==> uniqueList[m] in originalList
//     {
//       if !(originalList[i] in uniqueList) {
//         uniqueList := uniqueList + [originalList[i]];
//       }
//       i := i + 1;
//     }
//     return uniqueList;
//   }


//   method Initialize(fileList: seq<array<char>>)
//     modifies this
//   {
//     var uniqueFileList := EnsureUniqueFileList(fileList);
//     var i := 0;
//     while i < |uniqueFileList|
//       invariant 0 <= i && i <= |uniqueFileList|
//       // invariant forall k :: 0 <= k && k < i ==> uniqueFileList[k] in fileNames // State of fileNames invariant
//       // invariant |fileNames| <= i
//       // invariant forall j, k :: 0 <= j && j < k && k < |fileNames| ==> fileNames[j] != fileNames[k] // Uniqueness invariant
//       // invariant forall m :: 0 <= m && m < i ==> uniqueFileList[m] in fileNames
//       // invariant forall j, k :: 0 <= j && j < k && k < |fileNames| ==> fileNames[j] != fileNames[k]
//       // invariant forall j :: 0 <= j && j < i ==> uniqueFileList[j] in fileNames
//       // invariant forall x :: x in old(fileNames) ==> x in fileNames
//       // invariant forall j :: 0 <= j && j < i ==> uniqueFileList[j].Length > 0
//       modifies this
//       decreases |uniqueFileList| - i

//     {
//       var fileToAdd := uniqueFileList[i];
//       if fileToAdd.Length > 0 && !(fileToAdd in fileNames) {
//         this.AddFile(fileToAdd);
//         assert fileToAdd in fileNames; // Assert post-condition of AddFile
//       }



//       // assert forall k :: 0 <= k && k <= i ==> uniqueFileList[k] in fileNames;
//       // assert forall j :: 0 <= j && j < i ==> uniqueFileList[j].Length > 0;
//       i := i + 1;

//     }
//   }

// }


class FileStream
  {
  // var fileSet: FileSet
  ghost var env:HostEnvironment
  function{:axiom} Name():string reads this
  function{:axiom} IsOpen():bool reads this
  constructor{:axiom} () requires false
  // constructor(env: HostEnvironment)
  //   ensures this.env == env
  // {
  //   this.env := env;
  //   fileSet := new FileSet();
  // }

  // method ManageFiles()
  //   modifies this.fileSet
  // {
  //   var s: seq<char> := "file1.txt";

  //   var file: array<char> :=  new char[|s|]['f', 'i', 'l', 'e', '1', '.', 't', 'x', 't'];
  //   assert file.Length > 0;
  //   if (file.Length > 0) {
  //     fileSet.AddFile(file);
  //   }

  // }

  static method{:axiom} Open(name:array<char>, ghost env:HostEnvironment)
    returns(ok:bool, f:FileStream)
    requires env.ok.ok()
    modifies env.ok
    ensures  env.ok.ok() == ok
    ensures  ok ==> fresh(f) && f.env == env && f.IsOpen() && f.Name() == name[..]

  method{:axiom} Close() returns(ok:bool)
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
    modifies this
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
}