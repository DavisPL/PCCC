include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

function GetPath(): string
{
    "~/id_rsa.pub"
}

method LoadRsaKey(fPath: seq<char>)
requires fPath == GetPath()
{
    var f: FileStream;
    var ok: bool;
    ok, f := FileStream.Open(fPath);
    if !ok { print "open failed\n"; return; }
    var data: array<byte> := new byte[100];
    var pathTraversal := f.NoPathTraversal(fPath);
    var isAbsolutePath := f.IsAbsolutePath(fPath);
    ok := f.Read(fPath, 0, data, 0, data.Length as int32);
    print "Read public key!\n";

}