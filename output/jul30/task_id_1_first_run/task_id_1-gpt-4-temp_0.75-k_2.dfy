include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method Append(path: seq<char>, fname: seq<char>) 
    requires !IsDangerousPath(path) 
    requires !IsDangerousPath(fname) 
    requires HasAbsolutePath(path) 
    requires HasAbsolutePath(fname) 
    requires IsValidPathName(path) 
    requires IsValidFileName(fname) 
    requires HasValidPathLength(path) 
    requires HasValidPathLength(fname) 
    requires HasValidPathLength(path + fname)
    requires JointPathSize(path, fname)
{
    var f: FileStream;
    var ok: bool;
    ok, f := FileStream.Open(fname);
    if !ok { print "open failed\n"; return; }

    var jointPath := f.Join(path, fname);
    assert jointPath == path + fname;
}