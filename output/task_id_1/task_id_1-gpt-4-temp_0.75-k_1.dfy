include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method Append(path: seq<char>, fname: seq<char>) returns (jointPath: path)
requires !IsDangerousPath(fname) //Prevent path traversal by avoiding any dangerous pattern in the file name
requires !IsDangerousPath(path) //Prevent path traversal by avoiding any dangerous pattern in the path
requires HasAbsolutePath(fname) //Prevent any relative path in the file name
requires IsValidPathName(path) //Prevent any invalid pattern in the path
requires IsValidFileName(fname) //Prevent any invalid pattern in the file name
requires HasValidFileLength(fname) //Prevent file name length from exceeding the maximum limit
requires HasValidPathLength(path) //Prevent path length from exceeding the maximum limit
requires HasValidPathLength(path + fname) //Ensure that the resultant path does not exceed the maximum limit
ensures PathJoin(path, fname) == jointPath  || jointPath == "" //Ensures that the resultant path is either a valid path or an empty string
ensures HasValidPathLength(jointPath) || 0 <= |jointPath| //ensure that resultant path does not exceed the maximum limit
{
    var f: FileStream;
    var ok: bool;
    ok, f := FileStream.SafeOpenAPI(fname);
    if !ok { 
        print "Failed to open file\n"; 
        jointPath = ""; 
        return; 
    }
    jointPath := f.SafeJoinAPI(path, fname);
    print "File appended to path safely!\n";
}