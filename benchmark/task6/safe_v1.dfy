// ln -s /Users/pari/pcc-llms/benchmark/files/srcIsLinked/src.txt /Users/pari/pcc-llms/benchmark/files/targetLink.txt
// dafny run --allow-external-contracts --allow-warnings --unicode-char:false /Users/pari/pcc-llms/benchmark/task6/safe_v1.dfy --target:cs --input /Users/pari/pcc-llms/stdlib/Filesystem.cs -- /Users/pari/pcc-llms/tests/targetLink.txt "System.ArgumentException:"
include "/Users/pari/pcc-llms/benchmark/task6/Filesystem.dfy"
import FS = Filesystem
import utils = Utils
import opened Wrappers
method Main(args: seq<string>) 
{
    if |args| == 0 {
      print("empty arguments");
      return;
    }
    if |args| != 3 {
      print("usage: " + args[0] + " FILE_PATH EXPECTED_ERROR_PREFIX");
      return;
    }
    var filePath := args[1];
    var expectedErrorPrefix := args[2];
    var f := new FS.Files.Init("dummy.txt", []);
    if |filePath| <= 0 {
        print("empty file path");
        return;
    }
    var linkRes := f.IsLink(filePath);
    if linkRes.Failure? {
        print("unexpected failure: " + linkRes.error);
        return;
    } else if(!linkRes.value) {
        print("Path is not a symbolic link \n");
        var openRes := f.Open(filePath);
        if openRes.Failure? {
            print("unexpected error: \n" + openRes.error);
            return;
        }
        var readRes := f.ReadBytesFromFile(filePath);
        if readRes.Failure? {
            print("unexpected failure: " + readRes.error);
            return;
        }
        print("Read bytes! \n", readRes.value);
        var readBytes := seq(|readRes.value|, i requires 0 <= i < |readRes.value| => readRes.value[i] as int);
        print("File read successfully! \n");
    } else {
        print("Path is a symbolic link \n", linkRes.value);
    }

}