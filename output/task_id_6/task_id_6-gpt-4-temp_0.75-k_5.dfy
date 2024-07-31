include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method ConstructPath(fileName: seq<char>) returns (fullPath: seq<char>)
 requires NonEmptyString(fileName)
 requires !IsDangerousPath(fileName)
 requires HasValidFileLength(fileName)
 requires IsValidFileName(fileName)
 requires JointPathSize("/home/user/documents/", fileName)
 ensures fullPath == "/home/user/documents/" + fileName
 {
   var fullPath := "/home/user/documents/".Join(fileName);
   print "Full Path is: " + fullPath;
 }