include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

include "filesystems/interface/effectful-interface.dfy"

method Append(path: seq<char>,  fname: seq<char>) returns (jointPath: path)
requires !IsDangerousPath(fname)
requires !IsDangerousPath(path)
requires HasAbsolutePath(fname)
requires IsValidPathName(path)
requires IsValidFileName(fname)
requires HasValidFileLength(fname)
requires HasValidPathLength(path)
requires HasValidPathLength(path + fname)
requires PathJoin(path, fname) == path + fname
{
   var f: FileStream;
   var ok: bool;
   ok, f := FileStream.Open(fname);
   if !ok { print "open failed\n "; return ""; }
   jointPath := Path.Join(path, fname);
}