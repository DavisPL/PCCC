include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method Copy(srcFile: seq<char>, dstFile: seq<char>)
requires is_valid_path_name(srcFile)
requires is_valid_path_name(dstFile)
requires non_empty_string(srcFile)
requires non_empty_string(dstFile)
requires is_valid_file_extension(srcFile)
requires is_valid_file_extension(dstFile)
requires !has_dangerous_pattern(srcFile)
requires !has_dangerous_pattern(dstFile)
requires has_vaild_path_length(srcFile)
requires has_vaild_path_length(dstFile)
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
