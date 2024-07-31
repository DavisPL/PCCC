include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method Append(path: seq<char>,  fname: seq<char>) returns (jointPath: seq<char>)
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
  if !ok { print "Open failed\n"; return; }
  jointPath := PathJoin(path, fname);
  print "File appended successfully!\n";
}