include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

function GetFileName(): string
{
    // This method should return the filename
    "public-key.txt"
}

method SafeRead(fname: seq<char>)
requires fname == GetFileName()
{
    var f: FileStream;
    var ok: bool;
    ok, f := FileStream.Open(fname);
    if !ok { print "open failed\n"; return; }
    var data: array<byte> := new byte[100];
    ok := f.Read(fname, 0, data, 0, data.Length as int32);
    print "Safe Read operation!\n";

}

// Prevents user from reading sensitive files or files without permission
// Read with checking user permissions for reading the file