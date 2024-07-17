const dirMaxLength := 4096
const fileMaxLength := 255
const fileMinLength := 4
const validDirCharacters := {'_', '.', '-', '/'}
const validFileCharacters := {'.', '-'}

predicate alpha_numeric(c: char)

{
    (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || (c >= '0' && c <= '9')
}


predicate validate_char(c: char)
{
    alpha_numeric(c) || c in validDirCharacters

}

predicate validate_file_char(c: char)
{
    alpha_numeric(c) || c in validFileCharacters
}

function string_concat(s: seq<char>): seq<char>
{
  if |s| == 0 then "" else ([s[|s| - 1]] + string_concat(s[..(|s| - 1)]))
}

lemma StringSliceLemma(s: seq<char>)
requires 0 <= |s|
ensures forall i:: 0 <= i < |s| ==> s[..(i+1)] == s[..i] + [s[i]]
{
    assert |s| == 0 || |s| > 0;
    assert forall i:: 0 <= i < |s| ==> s[..(i+1)] == s[..i] + [s[i]];
}


lemma StringConcatLemma(s: seq<char>)
    requires 0 <= |s|
    ensures forall i :: (0 <= i < |s|) ==> s[..(i + 1)] == s[..i] + [s[i]]
{
  if |s| == 0 {
  } else {
    StringSliceLemma(s);
  }
}



predicate ValidateFileName(fileName: seq<char>)
requires 0 <= |fileName| <= fileMaxLength
requires forall i :: 0 <= i < |fileName| ==> validate_file_char(fileName[i]) && alpha_numeric(fileName[0]) && alpha_numeric(fileName[|fileName| - 1])
ensures (forall i :: 0 <= i < |fileName| ==> validate_file_char(fileName[i]) && alpha_numeric(fileName[0]) && alpha_numeric(fileName[|fileName| - 1]))
{
  forall i :: 0 <= i < |fileName| ==> validate_file_char(fileName[i]) && alpha_numeric(fileName[0]) && alpha_numeric(fileName[|fileName| - 1])

}

method ContainsC(s: string, c: char) returns (result: bool)
  requires 'a' <= c <= 'z' || 'A' <= c <= 'Z' || '0' <= c <= '9'
  ensures result <==> (exists i :: 0 <= i < |s| && (s[i] == c)) || c in s
{
  result := false;
  var i := 0;
  while i < |s|
    invariant 0 <= i <= |s|
    invariant result <==> (exists k :: 0 <= k < i && (s[k] == c))
  {
    if s[i] == c {
      assert c in s;
      result := true;
      break;
    }
    assert result <==> (exists k :: 0 <= k < i && (s[k] == c));
    i := i + 1; 

  }

}

method ContainsSequence(list: seq<seq<char>>, sub: seq<char>) returns (result: bool)
  ensures result <==> (exists i :: 0 <= i < |list| && sub == list[i]) || sub in list
{
  result := false;
  for i := 0 to |list|
    invariant 0 <= i <= |list|
    invariant result <==> (exists k :: 0 <= k < i && sub == list[k])
  {
    if sub == list[i] {
      result := true;
      break;
    }
  }
}