include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method GeneratePath(fileName: seq<char>) returns (fullPath: seq<char>)
  requires is_valid_file_name(fileName)
  requires !has_dangerous_pattern(fileName)
  requires has_valid_file_length(fileName)
  {
      var directory: seq<char> := "/home/user/documents";
      fullPath := Join(directory, fileName);
  }