include "/Users/pari/pcc-llms/filesystems-api/interface/effectful-interface.dfy"

method GetFile(filename: seq<char>) returns (data: array<byte>)
 requires !has_dangerous_pattern(filename)
 requires is_valid_file_extension(filename)
 requires is_valid_file_name(filename)
 requires has_valid_file_length(filename)
 requires has_absoloute_path(filename)
 requires non_empty_string(filename)
 {
     var f: FileStream;
     var ok: bool;
     var path: array<char> := "/var/www/files/";
     var fullPath := Join(path, filename);
     ok, f := FileStream.Open(fullPath);
     if !ok { print "open failed"; return new byte[0]; }
     data := new byte[100];
     ok := f.Read(fullPath, 0, data, 0, data.Length as int32);
     print "File read completed!\n";
 }