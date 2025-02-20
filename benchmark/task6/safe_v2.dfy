// ln -s /Users/pari/pcc-llms/benchmark/files/srcIsLinked/src.txt /Users/pari/pcc-llms/benchmark/files/targetLink.txt
// dafny run --allow-external-contracts --allow-warnings --unicode-char:false /Users/pari/pcc-llms/benchmark/task6/safe_v1.dfy --target:cs --input /Users/pari/pcc-llms/stdlib/Filesystem.cs -- /Users/pari/pcc-llms/tests/targetLink.txt "System.ArgumentException:"
include "/Users/pari/pcc-llms/benchmark/task6/Filesystem.dfy"
import FS = Filesystem
import utils = Utils
import opened Wrappers
method Main(args: seq<string>) 
{
    expect |args| > 0;
    expect |args| == 3, "usage: " + args[0] + " FILE_PATH EXPECTED_ERROR_PREFIX";
    var filePath := args[1];
    var expectedErrorPrefix := args[2];
    var f := new FS.Files.Init("dummy.txt", []);
    expect |filePath| > 0;
    var linkRes := f.IsLink(filePath);
    print ("linkRes:  ",linkRes);
    expect linkRes.Success?, "unexpected failure: " + linkRes.error;
    expect !linkRes.value, "Path is a not symbolic link \n";
    var openRes := f.Open(filePath);
    expect openRes.Success?, "unexpected error: " + openRes.error;
    var readRes := f.ReadBytesFromFile(filePath);
    expect readRes.Success?, "unexpected failure: " + readRes.error;
    var readBytes := seq(|readRes.value|, i requires 0 <= i < |readRes.value| => readRes.value[i] as int);
    print("File read successfully! \n");
}