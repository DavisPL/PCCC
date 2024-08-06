include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 21fa41e5 (update output)
method CreateFullPath(fileName: seq<char>) returns (fullpath: seq<char>)
 requires !has_dangerous_pattern(fileName)
 requires is_valid_file_name(fileName)
 requires has_valid_file_length(fileName)
 requires is_valid_file_extension(fileName)
 {
    var directory: seq<char> := "/home/user/documents/";
    fullpath := Join(directory, fileName);
<<<<<<< HEAD
 }
=======
method CreateFilePath(fname: seq<char>) returns (fpath: path)
requires !IsDangerousPath(fname) 
requires HasAbsolutePath(fname) 
requires IsValidFileName(fname) 
requires HasValidFileLength(fname) 
ensures PathJoin("/home/user/documents", fname) == fpath || fpath == "" 
{
    fpath := SafeJoinAPI("/home/user/documents", fname);
}
>>>>>>> a0b6940b (Remove venv)
=======
 }
>>>>>>> 21fa41e5 (update output)
