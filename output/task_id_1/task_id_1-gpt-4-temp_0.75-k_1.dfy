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