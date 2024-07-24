include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

function GetFileName(): string
{
    // This method should return the filename
    "public-key.txt"
}

method SafeWrite(fname: seq<char>)
requires fname == GetFileName()
{
    var fname := "safeFile-1.txt";
    var f: FileStream;
    var ok: bool;
    ok, f := FileStream.Open(fname);
    if !ok { print "open failed\n"; return; }
    // This is "hello world!" in ascii.
    // The library requires the data to be an array of bytes, but Dafny has no char->byte conversions
    var data: array<byte> := ArrayFromSeq([104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 33, 10]);
    ok := f.Write(fname, 0, data, 0, data.Length as int32);
    print "Safe write operation!\n";

}