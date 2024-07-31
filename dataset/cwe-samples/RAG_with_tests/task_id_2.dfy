include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"
method SaveToFile(path: seq<char>, userData: seq<char>)
requires !has_dangerous_pattern(path)
requires has_vaild_path_length(path)
requires non_empty_string(path)
requires is_valid_str_length(userData)
requires has_absoloute_path(path)
requires is_valid_path_name(path)
requires is_valid_file_name(userData)
requires is_valid_file_extension(path)
requires get_file_extension(path) == "txt"
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