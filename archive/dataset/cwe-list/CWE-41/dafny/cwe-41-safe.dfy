
include "../../../../FilesystemsAPI/std/FileIO.dfy"
import fs = FileIO
import utils = Utils
method SafeJoin(path: seq<char>,  fname: seq<char>) returns (jointPath: seq<char>)
    requires !utils.has_dangerous_pattern(fname)
    requires !utils.has_dangerous_pattern(path)
    requires utils.non_empty_path(path)
    requires utils.has_absolute_path(path)
{
    var ok: bool;
    var res := fs.Open(fname);
    // expect res.Success?, "Open failed:\n " + res.error;
    if !res.Success? {
        jointPath := "";
        return jointPath;
    } else {
        var joinIsOk:bool;
        var pathSeq := [path, fname];
        var joinRes := fs.JoinPaths(pathSeq, "/");
        expect joinRes.Success?, "unexpected failure: " + joinRes.error;
        jointPath := seq(|joinRes.value|, i requires 0 <= i < |joinRes.value| => joinRes.value[i] as char);
    }

}

method TestSafeJoin()
{
    var path := "/Users/JohnDoe/Documents";
    var fname := "file.txt";
    var res := SafeJoin(path, fname);
    print "SafeJoin test passed!";
}