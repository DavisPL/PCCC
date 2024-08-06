include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method Append(path: seq<char>, fname: seq<char>) returns (jointPath: seq<char>)
requires !IsDangerousPath(fname)
requires !IsDangerousPath(path)
requires HasAbsolutePath(fname)
requires IsValidPathName(path)
requires IsValidFileName(fname)
requires HasValidFileLength(fname)
requires HasValidPathLength(path)
requires HasValidPathLength(path + fname)
ensures jointPath == path + fname
{
    var f: FileStream;
    var ok: bool;
    ok, f := FileStream.Open(fname);
    if !ok { print "Open failed\n"; return path; } // If file opening failed, return the original path
    jointPath := path + fname;
}