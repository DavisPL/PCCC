datatype path = path(length: int, data: seq<char>)

const sensitivePaths := ["/usr", "/System", "/bin", "/sbin", "/var", "/usr/local"]
function ContainsSensitivePath(p: path):bool
// ensures forall i :: 0 <= i <= |sensitivePaths|
{
    var i := 0;
    forall i | 0 <= i < |sensitivePaths|
    //    ensures 0 <= i <= |sensitivePaths|
    {
        // var s := sensitivePaths[i];
        // var sensitivePathLength := |s|;
        // if p.length >= sensitivePathLength &&
        //    s in p.data[..]
        // {
        //     // result := true;
        // }
        // i := i + 1;
    }
    returns false;
}


