include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

function GetSourceFileName(): string
{
    "/user-data/public-key.txt"
}

function GetDistFileName(): string
{
    "/user-data/public-info.txt"
}

method WriteToFile(dstFile: path, data: array<byte>)
  requires dstFile == GetDistFileName()
{
  var f: FileStream;
  var ok: bool;
  ok, f := FileStream.Open(dstFile);
  if !ok { 
    print "open failed\n"; 
    return;
  } 
    // Handle the int32 constraint
    var dataLength: int32;
    if data.Length <= 0x7fffffff {
        dataLength := data.Length as int32;
    } else {
        print "Data too large for int32\n";
        return;
    }
    var pathTraversal := f.NoPathTraversal(dstFile);
    var isAbsolutePath := f.IsAbsolutePath(dstFile);
    ok := f.Write(dstFile, 0, data, 0, dataLength);
    if !ok {
        print "write failed\n";
    } else {
        print "Safe write operation!\n";
    }
}

method ReadFile(fname: path) returns (data: array<byte>)
  requires fname == GetSourceFileName()
{
  var f: FileStream;
  var ok: bool;
  ok, f := FileStream.Open(fname);
  if !ok { 
    print "open failed\n"; 
    return new byte[0]; 
  }
  data := new byte[100];
  var dataLength: int32 := 100; 
  var pathTraversal := f.NoPathTraversal(fname);
  var isAbsolutePath := f.IsAbsolutePath(fname);
  ok := f.Read(fname, 0, data, 0, dataLength);
  if !ok {
    print "read failed\n";
    data := new byte[0]; 
  } else {
    print "Safe Read operation!\n";
  }
}

method Copy(srcFile: seq<char>, dstFile: seq<char>)
  requires srcFile == GetSourceFileName()
  requires dstFile == GetDistFileName()
{
  var data := ReadFile(srcFile);
  if data.Length == 0 {
    print "Copy failed: couldn't read source file\n";
    return;
  }
  if data.Length > 0x7fffffff {
    print "Copy failed: file too large (exceeds int32 maximum)\n";
    return;
  }
  WriteToFile(dstFile, data);
}

method Main()
{
  var srcFile := GetSourceFileName();
  var dstFile := GetDistFileName();
  Copy(srcFile, dstFile);
}
