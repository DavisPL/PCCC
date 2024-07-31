include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

include "/path/to/file/operations/library.dfy"

method AppendFileToPath(path: seq<char>, fname: seq<char>) returns (jointPath: seq<char>)
    requires !IsDangerousPath(path)
    requires !IsDangerousPath(fname)
    requires HasAbsolutePath(path)
    requires IsValidPathName(path)
    requires IsValidFileName(fname)
    requires HasValidFileLength(fname)
    requires HasValidPathLength(path)
    requires HasValidPathLength(path + fname)
    requires PathJoin(path, fname) == path + fname
{
    var f: FileStream;
    var ok: bool;
    ok, f := FileStream.Open(fname);
    if !ok { print "open failed\n"; return; }

    jointPath := f.Join(path, fname);
}