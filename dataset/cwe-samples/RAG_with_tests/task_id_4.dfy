include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

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
  var f: FileStream;
  var ok: bool;
  ok, f := FileStream.Open(srcFile);
  if !ok { 
    print "open failed\n"; 
    return; 
  }
  var data := new byte[100];
  var dataLength: int32 := 100; 
  ok := f.Read(srcFile, 0, data, 0, dataLength);
  var f2: FileStream;
  ok, f2:= FileStream.Open(dstFile);
    if !ok { 
    print "open failed\n"; 
    return; 
  }
  ok := f2.Write(dstFile, 0, data, 0, data.Length as int32);
}

// method testWrite()
// {
//   var srcFile: seq<char> := "/usr/data/file.txt";
//   var dstFile: seq<char> := "/filecopy.txt";
//   Copy(srcFile, dstFile);
// }
