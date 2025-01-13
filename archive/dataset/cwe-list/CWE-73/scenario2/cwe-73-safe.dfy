include "../../../../filesystems-api/interface/effectful-interface.dfy"
method ReadLogFile(service: seq<char>, logName: seq<char>) returns (userData: seq<char>)
requires service in allowedServices
requires |logName| > 0
{
    var pathArray := new string[3];
    pathArray[0] := "/var/log";
    pathArray[1] := service;
    pathArray[2] := logName;
    var finalPath := JoinPaths(pathArray, "/");
    var f: FileStream;
    var ok: bool;
    if (finalPath !in sensitivePaths && !non_empty_string(finalPath) && !has_dangerous_pattern(finalPath)) {
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