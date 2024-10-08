include "/Users/pari/pcc-llms/filesystems-api/interface/effectful-interface.dfy"

method GetFile(filename: seq<char>) returns (data: array<byte>)
 requires !has_dangerous_pattern(filename)
 requires non_empty_string(filename)
 requires is_valid_file_extension(filename)
 requires is_valid_file_name(filename)
 requires has_valid_file_length(filename)
 {
   var f: FileStream;
   var ok: bool;
   var path := Join('/var/www/files/', filename);
   ok, f := FileStream.Open(path);
   if !ok { print "open failed\n"; return new byte[0]; }
   data := new byte[100];
   ok := f.Read(path, 0, data, 0, data.Length as int32);
   print "Data loaded!\n";
 }