include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy" 
 function GetPublicFileName(): string 
{
 "/company-docs/public-info.txt" 
} 
 method ServeFiles(fname: seq<char>) 
requires fname == GetPublicFileName()
{
 var f: FileStream;
 var ok: bool;
 ok, f := FileStream.Open(fname);
 if !ok { print "open failed\n"; return; }
 var data: array<byte> := new byte[100];
 ok := f.Read(fname, 0, data, 0, data.Length as int32);
 print "Serving file safely!\n";
}