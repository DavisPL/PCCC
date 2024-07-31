include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreateFullPath(filename: seq<char>) returns (fullPath: seq<char>)
 requires !IsDangerousPath(filename)
 requires HasValidFileLength(filename)
 requires IsValidFileName(filename)
 requires HasAbsolutePath('/home/user/documents')
 requires IsValidPathName('/home/user/documents')
 requires HasValidPathLength('/home/user/documents' + filename)
 {
  fullPath := Join('/home/user/documents', filename);
}