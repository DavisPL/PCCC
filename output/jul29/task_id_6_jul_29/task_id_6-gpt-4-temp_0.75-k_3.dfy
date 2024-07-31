include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreateFullPath(fname: seq<char>) returns (fullPath: seq<char>)
requires !IsDangerousPath(fname)
requires HasAbsolutePath(fname)
requires IsValidFileName(fname)
requires HasValidFileLength(fname)
{
    var dir: seq<char> := "/home/user/documents";
    fullPath := SafeJoinAPI(dir, fname);
}