include "../../../../FilesystemsAPI/Interface/EffectfulInterface.dfy"
method GetUserData(userName: seq<char>) returns (userData: seq<char>)
requires is_alpha_numeric(userName)
requires |userName| > 0
{
    var pathArray := new string[3];
    pathArray[0] := "/home";
    pathArray[1] := userName;
    pathArray[2] := "user-data.txt";
    var finalPath := JoinPaths(pathArray, "/");
    var f: FileStream;
    var ok: bool;
    if ( !non_empty_string(finalPath) && !has_dangerous_pattern(finalPath)) {
        print "Safe path";
        ok, f := FileStream.Open(finalPath);
        if !ok { print "open failed"; return; }
        var data := new byte[100];
        ok := f.Read(finalPath, 0, data, 0, data.Length as int32);
        print "Read operation terminated safely";
    } else {
        print "Sensitive path";
        userData := "";
    }
}