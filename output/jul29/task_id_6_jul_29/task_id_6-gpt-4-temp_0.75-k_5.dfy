include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreateFilePath(fname: seq<char>) returns (fullPath: seq<char>)
requires NonEmptyString(fname)
requires HasValidFileLength(fname)
requires IsValidFileName(fname)
requires IsValidFileExtension(fname)
requires !IsDangerousPath(fname)
ensures HasValidPathLength(fullPath)
ensures fullPath == "/home/user/documents" + fname
{
    var p: path := "/home/user/documents";
    fullPath := SafeJoinAPI(p, fname);
    print "Full file path created!\n";
}