include "../../../archive/interface/EffectfulInterface.dfy"
method ReadFile(path: seq<char>)
requires !has_dangerous_pattern(path)
requires is_valid_path_name(path)
requires non_empty_string(path)
requires is_valid_file_extension(path)
requires has_valid_path_length(path)
requires has_absolute_path(path)
requires has_valid_path_length(path)
requires is_valid_file_extension(path)
{
    var f: FileStream;
    var ok: bool;
    ok, f := FileStream.Open(path);
    if !ok { print "open failed"; return; }
    var data := new byte[100];
    ok := f.Read(path, 0, data, 0, data.Length as int32);
    print "Read operation terminated safely";
}