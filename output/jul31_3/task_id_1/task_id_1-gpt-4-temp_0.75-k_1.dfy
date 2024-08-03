include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

class File {
    var content: seq<char>;
    
    method Append(data: seq<char>) 
    modifies this
    ensures content == old(content) + data
    {
        content := content + data;
    }
}

method AppendToFile(file: File, data: seq<char>) 
  requires file != null 
  ensures file.content == old(file.content) + data 
  {
      file.Append(data);
  }