include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method Append(path: seq<char>, fname: seq<char>) returns (jointPath: seq<char>)
    requires !IsDangerousPath(path)
    requires !IsDangerousPath(fname)
    requires IsValidPathName(path)
    requires IsValidFileName(fname)
    requires GetPathLength(path) > 0
    requires GetPathLength(fname) > 0
    requires GetPathLength(PathJoin(path, fname)) <= GetPathLength(path) + GetPathLength(fname)
    ensures GetPathLength(jointPath) > 0
    ensures GetPathLength(jointPath) <= GetPathLength(path) + GetPathLength(fname)
    {
        var ok: bool;
        var f: FileStream;
        ok, f := FileStream.Open(fname);
        if !ok {
            print "open failed\n";
            jointPath := "";
            return;
        }
        jointPath := FileStream.Join(path, fname);
        print "Appended file to path safely!\n";
    }