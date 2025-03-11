method SplitPath(path: string) returns (head: string, tail: string)
ensures |path| == 0 ==> head == "" && tail == ""
ensures (forall i:: 0 <= i < |path| ==> path[i] != '/') ==> head == "" && tail == path
ensures path == head + tail
ensures head != "" && tail != "" ==> head == path[..|head|] && tail == path[|head|..]
ensures |head| == (|path| - 1) && tail == "" ==> head == path[..|path|-1] && tail == path[|head|..]
{
    var slashIdx := LastSlash(path);
    if slashIdx == -1 {
        head, tail := "", path;  // No slash found    
    } 
    head, tail := path[..slashIdx + 1], path[slashIdx + 1..]; 
    assert path == head + tail;
    print "head", "\n", head, "\n";
    print "tail", "\n", tail, "\n";
}


method LastSlash(s: string) returns (idx: int)
ensures -1 <= idx < |s|
ensures idx == -1 ==> (forall i:: 0 <= i < |s| ==> s[i] != '/')
ensures s == s[..idx+1] + s[idx+1..]
ensures idx != -1 ==> (forall i :: idx < i < |s| ==> s[i] != '/') && s[idx] == '/'
ensures |s| > 0 && s[|s|-1] == '/' ==> idx == |s|-1
ensures s == "/" ==> idx == 0
{
    idx := -1;
    var i := |s| - 1;
    while i >= 0
        decreases i
        invariant -1 <= i < |s|
        invariant idx != -1 ==> s[idx] == '/' &&  (forall i :: idx < i < |s| ==> s[i] != '/')
        invariant (idx == -1 ==> (forall j :: i < j < |s| ==> s[j] != '/'))
    {
        if s[i] == '/' {
            idx := i;
            assert i == idx;
            assert s[idx] == '/';
            print "\n", "Input", "\n", s;
            print "\n", "Last slash index @", "\n", idx;
            print "\n", "---------------", "\n";
            assert if s == "/" then idx == 0 else idx == i;
            break;
        }
        assert s[i] != '/';
        assert idx != i;
        i := i - 1;
    }
    assert idx == -1 || (0 <= idx < |s| && s[idx] == '/');
}

method SplitAll(path: string) returns (parts: seq<string>)
ensures path == "/" ==> parts == []
ensures |path| == 0 ==> parts == []
ensures path != "/" && |path| > 0 && path[0] == '/' ==> (forall p :: p in parts ==> |p| > 0)
decreases |path|
{
    if |path| == 0 || path == "/" {
        return [];
    }
    var head, tail := SplitPath(path);
    
    if head == "" && tail == "" {
        return []; 
    } else if head == "" && tail != "" {
        return [tail]; 
    }  else if head == path {
        parts := SplitAll(path[..|path| - 1]);
    } else {
        var firstPart := tail;
        var remainingParts := SplitAll(head[..|head|-1]);

        if |firstPart| > 0 {
            return remainingParts + [firstPart];
        } else {
            return remainingParts;
        }
    }
}

method SplitAllWithSlashes(path: string) returns (parts: seq<string>)
  ensures path == "/" ==> parts == ["/"]
  ensures |path| == 0 ==> parts == []
  ensures forall p :: p in parts ==> |p| > 0
  decreases |path| 
{
    if |path| == 0 {
        return [];
        return;
    } else if path == "/" {
        return ["/"];
    }

    var head, tail := SplitPath(path);

    if head == "" {
        if |tail| > 0 {
            return [tail];
        } else {
            return [];  
        }
    }

    var firstPart := tail;
    var remainingParts := SplitAllWithSlashes(head[..|head|-1]);
    if |firstPart| > 0 {
        return remainingParts + ["/"] + [firstPart];
    } else {
        return  remainingParts;
    }
}
