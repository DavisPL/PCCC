include "../../../../../FilesystemsAPI/Interface/EffectfulInterface.dfy"
method GetUserData(userName: seq<char>) returns (userData: seq<char>)
required_preconditions
{
    var pathArray := new string[3];
    pathArray[0] := "/home";
    pathArray[1] := userName;
    pathArray[2] := "user-data.txt";
    var finalPath := JoinPaths(pathArray, "/");
    var f: FileStream;
    var ok: bool;
    ok, f := FileStream.Open(finalPath);
    if !ok { print "open failed"; return; }
    var data := new byte[100];
    ok := f.Read(finalPath, 0, data, 0, data.Length as int32);
    print "Read operation terminated safely";
}