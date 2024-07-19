include "/Users/pari/pcc-llms/dataset/filesystems/effectful-interface/effectful-interface.dfy"
method{:main} Main(ghost env: HostEnvironment, fname: seq<char>)
// Prevents CWE-434 
// Prevent upload or transfer of dangerous file types
  requires env.ok.ok()
  modifies env.ok
  requires ValidateFileName(fname)
  requires IsValidFileType(fname[(|fname|-4)..], invalidFileTypes)
  requires ValidateNonsensitiveFileFunc(fname, nonSensitiveFilesList)
//   requires !ContainsSequence(fname, invalidFileTypes)
//   requires validate_nonsensitive_file(fname, nonSensitiveFilesList)

{
    var fname := "safeFile-1.txt";
     // Test case 2: Invalid file type
    // var fname := "unsafe.exe";
    // Test case 3: Sensitive file
    // var fname := "sensitive_data.txt";
    // Test case 4: Invalid file name
    // var fname := "invalid<>file.txt";
    var ftype := fname[(|fname|-4)..];
    var isValidFile := ValidateFileName(fname);
    // assert isValidFile;
    var nonSensitive := ValidateNonsensitiveFileFunc(fname, nonSensitiveFilesList);
    // assert nonSensitive;
    var validFileType := IsValidFileType(fname[(|fname|-4)..], invalidFileTypes);
    // assert validFileType;
    if isValidFile && nonSensitive && validFileType {
        var f: FileStream;
        var ok: bool;
        ok, f := FileStream.Open(fname, env);

        // Try commenting out the following line to see that you are forced to handle errors!
        if !ok { print "open failed\n"; return; }

        // This is "hello world!" in ascii.
        // The library requires the data to be an array of bytes, but Dafny has no char->byte conversions :(
        var data: array<byte> := ArrayFromSeq([104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 33, 10]);
        // Replace write with upload
        ok := f.Write(fname, 0, data, 0, data.Length as int32);
        print "Safe write operation!\n";
    } else {
        print "Unsafe write operation! \n";
        return;
    }

}


// /// Convert SafeWriteEffect to a function
// function SafeWriteEffect(env: HostEnvironment, fname: seq<char>): bool
//   reads env
// {
//   env.ok.ok() &&
//   ValidateFileName(fname) &&
//   IsValidFileType(fname[(|fname|-4)..], invalidFileTypes) &&
//   ValidateNonsensitiveFileFunc(fname, nonSensitiveFilesList)
// }

// // SafeWrite method
// method SafeWrite(env: HostEnvironment, fname: seq<char>) returns (success: bool)
//   requires SafeWriteEffect(env, fname)
//   modifies env.ok
//   ensures env.ok.ok() ==> success
//   ensures !success ==> !env.ok.ok()
// {
//   var f: FileStream;
//   var ok: bool;
//   ok, f := FileStream.Open(fname, env);

//   if !ok {
//     print "open failed\n";
//     env.ok.UpdateOk(false);
//     return false;
//   }

//   var data: array<byte> := ArrayFromSeq([104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 33, 10]);
  
//   ok := f.Write(fname, 0, data, 0, data.Length as int32);
//   if ok {
//     print "Safe write operation successful!\n";
//     return true;
//   } else {
//     print "Write operation failed.\n";
//     env.ok.UpdateOk(false);
//     return false;
//   }
// }

// method {:main} Main(ghost env: HostEnvironment, fname: seq<char>)
//   requires env.ok.ok()
//   modifies env.ok
//   ensures SafeWriteEffect(old(env), fname) ==> env.ok.ok()
//   ensures !SafeWriteEffect(old(env), fname) ==> !env.ok.ok()
// {
// //   if SafeWriteEffect(env, fname) {
// //     var writeSuccess := SafeWrite(env, fname);
// //     if writeSuccess {
// //       print "File operation completed successfully.\n";
// //     } else {
// //       print "File operation failed.\n";
// //     }
// //   } else {
// //     print "Unsafe write operation! File validation failed.\n";
// //     env.ok.UpdateOk(false);
// //   }
// }

// // Test harness for Main method
// method TestMain()
// {
//   // Test case 1: Valid file
//   var env1 := new HostEnvironment();
//   var fname1 := "safeFile-1.txt";
//   Main(env1, fname1);
//   assert env1.ok.ok();

//   // Test case 2: Invalid file type
//   var env2 := new HostEnvironment();
//   var fname2 := "unsafe.exe";
//   Main(env2, fname2);
//   assert !env2.ok.ok();

//   // Test case 3: Sensitive file
//   var env3 := new HostEnvironment();
//   var fname3 := "sensitive_data.txt";
//   Main(env3, fname3);
//   assert !env3.ok.ok();

//   // Test case 4: Invalid file name
//   var env4 := new HostEnvironment();
//   var fname4 := "invalid<>file.txt";
//   Main(env4, fname4);
//   assert !env4.ok.ok();

//   print "All test cases completed.";
// }

