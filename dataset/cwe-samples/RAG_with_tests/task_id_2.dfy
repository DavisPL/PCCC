include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"
method SaveToFile(path: seq<char>, userData: seq<char>)
requires !IsDangerousPath(path)
requires HasValidPathLength(path)
requires NonEmptyString(path)
requires StrContentLengthIsValid(userData)
requires HasAbsolutePath(path)
requires IsValidPathName(path)
requires IsValidFileName(userData)
requires IsValidFileExtension(path)
{
    var f: FileStream;
    var ok: bool;
    var data: array<byte> := ArrayFromSeq(StringToBytes(userData));
    ok, f := FileStream.Open(path);
    if !ok { print "open failed\n"; return; }
    if ( data.Length == 0 ) { print "Empty data\n"; return; }
    ok := f.Write(path, 0, data, 0, data.Length as int32);
    print "Safe write operation!\n";

}

// method testSafeWrite()
// {
//     var path: seq<char> := "/usr/data/file.txt";
//     var userData: seq<char> := "This is a test";

//     SaveToFile(path, userData);
// }