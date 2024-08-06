include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreateFullPath(filename: seq<char>) returns (fullPath: seq<char>)
 requires NonEmptyString(filename)
 requires !IsDangerousPath(filename)
 requires IsValidFileName(filename)
 requires HasValidFileLength(filename)
 {
    var directory: seq<char> := "/home/user/documents";
    var f: FileStream;
    var ok: bool;
    ok, f := FileStream.Open(directory);
    if !ok { print "open failed
 "; return "";}
    fullPath := f.Join(directory, filename);
    print "Full path created!
    ";
}"