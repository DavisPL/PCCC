include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"
method LoadUserData(path: seq<char>, userName: string)
requires !IsDangerousPath(path)
requires IsValidFileExtension(path)
requires IsValidPathName(path)
requires NonEmptyString(userName)
requires !IsDangerousPath(userName)
requires HasValidPathLength(path)
requires HasAbsolutePath(path)
{
    var f: FileStream;
    var ok: bool;
    ok, f := FileStream.Open(path);
    if !ok { print "open failed\n"; return; }
    var data := new byte[100];
    ok := f.Read(path, 0, data, 0, data.Length as int32);
    print "User data loaded!\n";

}