include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"


method SafeWrite(path: seq<char>, userData: seq<char>)

{
    var f: FileStream;
    var ok: bool;
    var data: array<byte> := ArrayFromSeq(StringToBytes(userData));
    
    ok, f := FileStream.Open(path);
    if !ok { print "open failed\n"; return; }
    // ok := f.Write(path, 0, data, 0, data.Length as int32);
    print "Safe write operation!\n";

}

// method testSafeWrite()
// {
//     var path: seq<char> := "/usr/data/";
//     var userData: seq<char> := "This is a test";
//     var a:= has_absolute_path(path);
//     // assert !a;
//     SafeWrite(path, userData);
// }