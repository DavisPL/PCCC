include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"
method LoadUserData(path: seq<char>, userName: string)
requires !has_dangerous_pattern(path)
requires is_valid_file_extension(path)
requires is_valid_path_name(path)
requires non_empty_string(userName)
requires !has_dangerous_pattern(userName)
requires has_vaild_path_length(path)
requires has_absoloute_path(path)
requires is_valid_file_extension(path)
{
    var f: FileStream;
    var ok: bool;
    ok, f := FileStream.Open(path);
    if !ok { print "open failed\n"; return; }
    var data := new byte[100];
    ok := f.Read(path, 0, data, 0, data.Length as int32);
    print "User data loaded!\n";

}