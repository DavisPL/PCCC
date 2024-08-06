include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method CreateFilePath(fname: seq<char>, path: seq<char>) returns(fullPath: seq<char>)
 requires !has_dangerous_pattern(fname)
 requires !has_dangerous_pattern(path)
 requires has_absoloute_path(fname)
 requires is_valid_path_name(path)
 requires is_valid_file_name(fname)
 requires has_valid_file_length(fname)
 requires has_valid_path_length(path)
 requires has_valid_path_length(path + fname)
 requires append_file_to_path(path, fname) == path + fname
 requires is_valid_file_extension(path)
{
    var f: FileStream;
    var ok: bool;
    fullPath := f.Join(path, fname);
}