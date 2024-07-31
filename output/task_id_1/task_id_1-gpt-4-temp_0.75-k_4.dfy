include "/Users/pari/pcc-llms/dataset/filesystems/interface/effectful-interface.dfy"

method AppendToFile(path: seq<char>, content: seq<char>)
requires !IsDangerousPath(path)
requires HasAbsolutePath(path)
requires IsValidPathName(path)
requires NonEmptyString(content)
ensures FileContent(path) == old(FileContent(path)) + content