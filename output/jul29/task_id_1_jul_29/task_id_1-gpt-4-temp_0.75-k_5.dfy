include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method AppendFileToPath(path: seq<char>, file: seq<char>) returns (result: path)
    requires !IsDangerousPath(path)
    requires !IsDangerousPath(file)
    requires HasAbsolutePath(path)
    requires IsValidPathName(path)
    requires IsValidFileName(file)
    requires HasValidFileLength(file)
    requires HasValidPathLength(path)
    requires HasValidPathLength(path + file)
    ensures result == SafeJoinAPI(path, file) || result == null
{
    var ok: bool;
    var f: FileStream;
    ok, f := FileStream.SafeOpenAPI(file);
    if !ok {
        print "open failed\n";
    }
    
    result := SafeJoinAPI(path, file);
    print "File appended to path!\n";
}