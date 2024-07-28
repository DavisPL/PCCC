include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method WriteToFile(path: path, data: array<byte>)
requires !IsDangerousPath(path)
requires IsValidPathName(path)
requires HasValidPathLength(path)
requires IsValidFileExtension(path)
requires ByteContentLengthIsValid(data)
{
  var f: FileStream;
  var ok: bool;
  ok, f := FileStream.SafeOpenAPI(path);
  if !ok { 
    print "open failed\n"; 
    return;
  } 
  ok := f.SafeWriteAPI(path, 0, data, 0, data.Length as int32);
  if !ok {
      print "write failed\n";
  } else {
      print "Safe write operation!\n";
  }
}

method ReadFile(path: path) returns (data: array<byte>)
  requires !IsDangerousPath(path)
  requires IsValidPathName(path)
  requires NonEmptyString(path)
  requires IsValidFileExtension(path)
  ensures ByteContentLengthIsValid(data)
{
  var f: FileStream;
  var ok: bool;
  ok, f := FileStream.SafeOpenAPI(path);
  if !ok { 
    print "open failed\n"; 
    return new byte[0]; 
  }
  data := new byte[100];
  var dataLength: int32 := 100; 
  ok := f.SafeReadAPI(path, 0, data, 0, dataLength);
  if !ok {
    print "read failed\n";
    data := new byte[0]; 
  } else {
    print "Safe Read operation!\n";
  }
}

method Copy(srcFile: seq<char>, dstFile: seq<char>)
requires IsValidPathName(srcFile)
requires IsValidPathName(dstFile)
requires NonEmptyString(srcFile)
requires NonEmptyString(dstFile)
requires IsValidFileExtension(srcFile)
requires IsValidFileExtension(dstFile)
requires !IsDangerousPath(srcFile)
requires !IsDangerousPath(dstFile)
requires HasValidPathLength(srcFile)
requires HasValidPathLength(dstFile)

{
  var data := ReadFile(srcFile);
  WriteToFile(dstFile, data);
}

// method testSafeWrite()
// {
//   var srcFile: seq<char> := "/usr/data/file.txt";
//   var dstFile: seq<char> := "/filecopy.txt";
//   Copy(srcFile, dstFile);
// }
