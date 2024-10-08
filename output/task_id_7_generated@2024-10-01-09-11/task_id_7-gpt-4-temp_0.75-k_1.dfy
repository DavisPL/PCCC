include "/Users/pari/pcc-llms/filesystems-api/interface/effectful-interface.dfy"

method GetFile(filename: seq<char>) returns (data: array<byte>)
 requires !has_dangerous_pattern(filename)
 requires is_valid_file_name(filename)
 requires non_empty_string(filename)
 {
     var ok: bool;
     var f: FileStream;
     var basePath: seq<char> := "/var/www/files/";
     var fullPath: seq<char> := Join(basePath, filename);
     ok, f := FileStream.Open(fullPath);
     if !ok { print "open failed\n"; return new byte[0]; }
     data := new byte[100];
     ok := f.Read(fullPath, 0, data, 0, data.Length as int32);
     print "Data fetched successfully\n";
 }