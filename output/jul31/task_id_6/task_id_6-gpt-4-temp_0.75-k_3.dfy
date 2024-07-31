include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method FullFilePath(fileName: seq<char>) returns (fullFilePath: seq<char>)
 requires non_empty_string(fileName)
 requires !has_dangerous_pattern(fileName)
 requires has_absoloute_path(fileName)
 requires is_valid_file_name(fileName)
 requires has_valid_file_length(fileName)
 requires is_valid_file_extension(fileName)
{
 var path: seq<char> := "/home/user/documents";
 var f: FileStream;
 var ok: bool;
 ok, f := FileStream.Open(path);
 if !ok { 
   print "open failed"; 
   return; 
 }
 fullFilePath := f.Join(path, fileName);
 print "Full file path created";
}