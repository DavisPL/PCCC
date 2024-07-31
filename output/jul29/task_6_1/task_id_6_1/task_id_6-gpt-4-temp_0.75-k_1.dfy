include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreateFile(fileName: seq<char>) returns (filePath: path)
requires IsValidFileName(fileName)
requires NonEmptyString(fileName)
requires IsValidFileExtension(fileName)
requires HasValidFileLength(fileName)
ensures HasAbsolutePath(filePath)
ensures HasValidPathLength(filePath)
ensures filePath == FilePathJoin("/home/user/documents", fileName)
{
    var ok: bool;
    var f: FileStream;
    var dirPath: seq<char> := "/home/user/documents";
    filePath := FilePathJoin(dirPath, fileName);
    ok, f := FileStream.SafeOpenAPI(filePath);
    if !ok { print "file open failed\n"; return; }
    print "File created successfully!\n";
    f.Close();
}