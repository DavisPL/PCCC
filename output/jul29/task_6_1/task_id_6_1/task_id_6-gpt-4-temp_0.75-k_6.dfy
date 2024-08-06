include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreateFullPath(fname: seq<char>) returns (path: seq<char>)
requires !IsDangerousPath(fname)
requires HasAbsolutePath(fname)
requires IsValidFileName(fname)
{
   var p: path := "/home/user/documents";
   var result: path := SafeJoinAPI(p, fname);
   path := result;
}