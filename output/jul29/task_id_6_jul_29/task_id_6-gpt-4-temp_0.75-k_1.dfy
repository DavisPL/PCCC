include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreateFullPath(fname: seq<char>) returns (fullPath: seq<char>)
    requires !IsDangerousPath(fname)
    requires !HasAbsolutePath(fname)
    requires IsValidFileName(fname)
    requires HasValidFileLength(fname)
    requires HasValidPathLength("/home/user/documents" + fname)
    ensures fullPath == "/home/user/documents" + fname
    {
        return "/home/user/documents" + fname;
    }