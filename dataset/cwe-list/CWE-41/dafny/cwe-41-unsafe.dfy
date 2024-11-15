
include "../../../../FilesystemsAPI/std/FileIO.dfy"
import fs = FileIO
import utils = Utils
method UnsafeJoin(path: seq<char>,  fname: seq<char>) returns (jointPath: seq<char>)
{
    var ok: bool;
    var res := fs.Open(fname);
    expect res.Success?, "Open failed:\n " + res.error;
    var joinIsOk:bool;
    var pathSeq := [path, fname];
    var joinRes := fs.JoinPaths(pathSeq, "/");
    expect joinRes.Success?, "unexpected failure: " + joinRes.error;
    jointPath := seq(|joinRes.value|, i requires 0 <= i < |joinRes.value| => joinRes.value[i] as char);
}
