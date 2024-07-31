include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method Append(path: seq<char>, fname: seq<char>) returns (jointPath: seq<char>)
    requires !IsDangerousPath(fname) 
    requires !IsDangerousPath(path) 
    requires HasAbsolutePath(fname) 
    requires IsValidPathName(path) 
    requires IsValidFileName(fname) 
    requires HasValidFileLength(fname) 
    requires HasValidPathLength(path) 
{
    var ok: bool;
    var f: FileStream;
    ok, f := FileStream.SafeOpenAPI(fname);
    if !ok {
        print "open failed\n";
        return "";
    }
    var jointPath := SafeJoinAPI(path, fname);
    return jointPath;
}