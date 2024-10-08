include "../../../../filesystems-api/interface/effectful-interface.dfy"
method GetUserData(userName: seq<char>) returns (userData: seq<char>)

{
    var pathArray := new string[3];
    pathArray[0] := "/home";
    pathArray[1] := userName;
    pathArray[2] := "user-data.txt";
    // if (!is_alpha_numeric(userName)) { print "Invalid username"; return; }
    var finalPath := JoinPaths(pathArray, "/");
    var f: FileStream;
    var ok: bool;
    // var isReal := IsRealLink(finalPath);
    // if (finalPath !in sensitivePaths && !non_empty_string(finalPath) && !has_dangerous_pattern(finalPath) && isReal) {
        ok, f := FileStream.Open(finalPath);
        if !ok { print "open failed"; userData := ""; }
        var data := new byte[100];
        ok := f.Read(finalPath, 0, data, 0, data.Length as int32);
        print "Read operation terminated safely";
    // } else {
    //     // print "Sensitive path";
    //     userData := "";
    // }
}