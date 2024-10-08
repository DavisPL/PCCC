include "/Users/pari/pcc-llms/filesystems-api/interface/effectful-interface.dfy"

method GetFile(filename: seq<char>) returns (data: array<byte>)
 requires !has_dangerous_pattern(filename)
 requires is_valid_path_name(filename)
 requires non_empty_string(filename)
 requires is_valid_file_extension(filename)
 {
     var basePath:seq<char> := "/var/www/files/";
     var fullPath := Join(basePath, filename);
     var f: FileStream;
     var ok: bool;
     ok, f := FileStream.Open(fullPath);
     if !ok { print "open failed"; return new byte[0]; }
     data := new byte[100];
     ok := f.Read(fullPath, 0, data, 0, data.Length as int32);
     f.Close();
 }