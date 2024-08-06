include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreateFilePath(fname: seq<char>) returns (fpath: path)
requires !IsDangerousPath(fname) 
requires HasAbsolutePath(fname) 
requires IsValidFileName(fname) 
requires HasValidFileLength(fname) 
ensures PathJoin("/home/user/documents", fname) == fpath || fpath == "" 
{
    fpath := SafeJoinAPI("/home/user/documents", fname);
}