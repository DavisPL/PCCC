include "/Users/pari/pcc-llms/filesystems-api/interface/effectful-interface.dfy"

method GetFile(filename: seq<char>) returns (data: array<byte>)
 requires !has_dangerous_pattern(filename)
 requires is_valid_file_name(filename)
 requires non_empty_string(filename)
 requires has_valid_file_length(filename)
 {
   var f: FileStream;
   var ok: bool;
   var dir: path := "/var/www/files/"; 
   var fullpath: path := Join(dir, filename);
   ok, f := FileStream.Open(fullpath);
   if !ok { print "open failed\n"; return new byte[0]; }
   data := new byte[100];
   ok := f.Read(fullpath, 0, data, 0, data.Length as int32);
   print "File data loaded!\n";
 }