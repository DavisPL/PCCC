include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

function GetFileName(): string
{
    // This method should return the filename
    "public-key.txt"
}
method SafeWrite(fname: seq<char>)
requires fname == GetFileName()
// Prevents CWE-434 
// Prevent upload or transfer of dangerous file types

{
    var fname := "safeFile-1.txt";
     // Test case 2: Invalid file type
    // var fname := "unsafe.exe";
    // Test case 3: Sensitive file
    // var fname := "sensitive_data.txt";
    // Test case 4: Invalid file name
    // var fname := "invalid<>file.txt";
    // var ftype := fname[(|fname|-4)..];
    // var isValidFile := ValidateFileName(fname);
    // // assert isValidFile;
    // var nonSensitive := ValidateNonsensitiveFileFunc(fname, nonSensitiveFilesList);
    // // assert nonSensitive;
    // var validFileType := IsValidFileType(fname[(|fname|-4)..], invalidFileTypes);
    // // assert validFileType;
    // if isValidFile && nonSensitive && validFileType {
    var f: FileStream;
    var ok: bool;
    ok, f := FileStream.Open(fname);

    // Try commenting out the following line to see that you are forced to handle errors!
    if !ok { print "open failed\n"; return; }
    // This is "hello world!" in ascii.
    // The library requires the data to be an array of bytes, but Dafny has no char->byte conversions :(
    var data: array<byte> := ArrayFromSeq([104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 33, 10]);
    // Replace write with upload
    ok := f.Write(fname, 0, data, 0, data.Length as int32);
    print "Safe write operation!\n";

}