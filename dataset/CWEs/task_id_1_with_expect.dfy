include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"


method JoinFileToPath(path: seq<char>,  fname: seq<char>) returns (jointPath: path)
requires  IsNonEmpty(fname)
requires !is_dangerous_path(fname)
requires !has_path_traversal(fname)
requires has_absolute_path(fname)
{
  var f: FileStream;
  var ok: bool;
  var notEmptyPath := IsNonEmpty(fname);
  var absPath := is_dangerous_path(fname);
  var is_dangerous_path := has_path_traversal(fname);
  // var hasValidChar := HasValidCharacters(path);
  expect notEmptyPath;
  expect absPath;
  expect !is_dangerous_path;
  expect !has_path_traversal(fname);
  expect has_absolute_path(fname);
  ok, f := FileStream.Open(fname);
  if !ok { print "open failed\n"; return "";}


  var joinIsOk:bool;
  joinIsOk, jointPath := f.Join(path, fname);
}

// method testJoinFileToPath()
// {
//   var path: seq<char> := "../../usr/data";
//   var fname: seq<char> := "public-info.txt";
//   var jointPath := JoinFileToPath(path, fname);
//   print jointPath;
// }
// method{:main} Main()
// {
  
//   print jointPath;
// }
