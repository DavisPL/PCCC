include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreateFullPath(fname: seq<char>) returns (fullPath: path) 
requires !IsDangerousPath(fname)
requires IsValidFileName(fname)
requires HasValidFileLength(fname)
{
  var predetDirectory: path := "/home/user/documents";
  fullPath := FileStream.SafeJoinAPI(predetDirectory, fname);
}