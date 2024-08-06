<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> fb1cbe8e (updated)
include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method AppendToFile(path: seq<char>, fname: seq<char>) returns (jointPath: seq<char>)
    requires !IsDangerousPath(path)
    requires IsValidPathName(path) 
    requires HasValidPathLength(path)
    requires IsValidFileName(fname)
    requires NonEmptyString(path)
    requires NonEmptyString(fname)
    ensures HasValidPathLength(jointPath)
    ensures jointPath == path + fname
{
    jointPath := PathJoin(path, fname);
<<<<<<< HEAD
}
=======
include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy" 

    function GetFileName(): string 
    {
        "example.txt" 
    } 

    function GetPath(): string 
    { 
        "/user-data/" 
    }

    method JoinFileToPath(path: seq<char>, fname: seq<char>) returns (jointPath: seq<char>)
    requires path == GetPath()
    requires fname == GetFileName()
    {
        var f: FileStream;
        var ok: bool;
        ok, f := FileStream.Open(fname);
        if !ok { 
            print "open failed\n"; 
            return ""; 
        }
        var joinIsOk: bool;
        joinIsOk, jointPath := f.Join(path, fname);
    }

    method {:main} Main() 
    {
        var path := GetPath();
        var fname := GetFileName();
        var jointPath := JoinFileToPath(path, fname);
        print jointPath;
    }
>>>>>>> 3f0f37c0 (updated)
=======
}
>>>>>>> fb1cbe8e (updated)
