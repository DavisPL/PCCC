include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreateFullPath(fileName: seq<char>) returns (fullPath: path)
requires NonEmptyString(fileName)
requires IsValidFileName(fileName)
requires HasValidFileLength(fileName)
{
  var directoryPath: path := "/home/user/documents";
  requires NonEmptyString(directoryPath);
  requires IsValidPathName(directoryPath);
  requires HasValidPathLength(directoryPath);
  requires HasAbsolutePath(directoryPath);
  fullPath := directoryPath.Join(fileName);
}