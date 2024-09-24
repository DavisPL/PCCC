include "../../../filesystems-api/interface/effectful-interface.dfy"
method GetFile(filename: seq<char>) returns (data: array<byte>)
// requires non_empty_string(filename)
// requires !has_dangerous_pattern(filename)
// requires is_valid_file_name(filename)
// requires has_valid_file_length(filename)
// requires is_valid_file_extension(filename)
{

    var f: FileStream;
    var ok: bool;
    var base_dir: seq<char> := "/var/www/files/";
    data := new byte[100];
    var file_path := Join(base_dir, filename);
    // if (!has_dangerous_pattern(file_path)) {
        print "base_dir is safe";
        ok, f := FileStream.Open(file_path);

        // if !ok { print "open failed"; return data; }
        // // if is_valid_file_extension(file_path) {
        //     print "file extension is valid";
        //     ok := f.Read(file_path, 0, data, 0, data.Length as int32);
        //     print "Read operation terminated safely";
    //     } else {
    //         print "file extension is invalid";
    //         return data;
    //     }

    // }  else {
    //         print "base_dir is unsafe";
    //         return data;
    // }
 
}