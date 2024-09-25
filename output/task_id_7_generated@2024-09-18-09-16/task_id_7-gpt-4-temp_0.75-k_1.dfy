include "/Users/pari/pcc-llms/filesystems-api/interface/effectful-interface.dfy"

method GetFile(filename: seq<char>) returns (data: array<byte>)
 requires non_empty_string(filename)
 requires !has_dangerous_pattern(filename)
 requires is_valid_file_name(filename)
 requires has_valid_file_length(filename)
 {
     var directory: seq<char> := "/var/www/files/";
     var f: FileStream;
     var fullpath := Join(directory, filename);
     var ok: bool;
     ok, f := Open(fullpath);
     if !ok { print "open failed"; return new byte[0]; }
     data := new byte[100];
     ok := f.Read(fullpath, 0, data, 0, data.Length as int32);
 }