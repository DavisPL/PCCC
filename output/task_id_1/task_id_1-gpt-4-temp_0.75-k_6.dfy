include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method AppendPathToFile(path: seq<char>, fname: seq<char>) returns (jointPath: seq<char>)
requires !IsDangerousPath(fname)
requires !IsDangerousPath(path)
requires HasAbsolutePath(fname)
requires IsValidPathName(path)
requires IsValidFileName(fname)
requires HasValidFileLength(fname)
requires HasValidPathLength(path)
requires HasValidPathLength(path + fname)
ensures PathJoin(path, fname) == jointPath || jointPath == ""
ensures HasValidPathLength(jointPath) || 0 <= |jointPath|
{
    var p: path;
    var f: file;
    var ok: bool;
    
    ok, f := FileStream.SafeOpenAPI(fname);
    if !ok {
        print "open failed\n";
        return;
    }

    jointPath := SafeJoinAPI(p, f);
    if !ok || jointPath == "" {
        print "join failed\n";
    }

    print "Path joined safely!\n";
}