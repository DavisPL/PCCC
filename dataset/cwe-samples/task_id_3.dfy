include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"
method SafeRead(fname: seq<char>)
// Prevents user from reading sensitive files or files without permission
// Read with checking user permissions for reading the file

{
    var fname := "safeFile-1.txt";
    var f: FileStream;
    var ok: bool;
    ok, f := FileStream.Open(fname);
    var user := "admin";
    if !ok { print "open failed\n"; return; }
    var data: array<byte> := new byte[100];
    ok := f.Read(fname, 0, data, 0, data.Length as int32);
    print "Safe Read operation!\n";

}