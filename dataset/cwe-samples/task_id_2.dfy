include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

function GetPath(): string
{
    "/user-data/public-info.txt"
}

function GetUserData(): string
{

    "User's private data"
}

method SafeWrite(fPath: seq<char>, userData: seq<char>)
requires fPath == GetPath()
requires userData == GetUserData()
{
    var f: FileStream;
    var ok: bool;
    ok, f := FileStream.Open(fPath);
    if !ok { print "open failed\n"; return; }
    var data: array<byte> := ArrayFromSeq(StringToBytes(userData));
    ok := f.Write(fPath, 0, data, 0, data.Length as int32);
    print "Safe write operation!\n";

}