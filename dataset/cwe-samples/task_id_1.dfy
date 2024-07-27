
include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method JoinFileToPath(path: seq<char>,  fname: seq<char>) returns (jointPath: path)
requires  IsNonEmpty(fname)
requires !is_dangerous_path(fname)
requires !ContainsConsecutivePeriods(fname)
requires has_absolute_path(fname)
requires is_valid_file(fname)

{
  var f: FileStream;
  var ok: bool;
  ok, f := FileStream.Open(fname);
  if !ok { print "open failed\n"; return "";}


  var joinIsOk:bool;
  joinIsOk, jointPath := f.Join(path, fname);
}
