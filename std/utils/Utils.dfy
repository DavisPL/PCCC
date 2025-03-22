module Utils
{
    type path = seq<char>
    type file = seq<char>
    type fileType = seq<char>
    type extension = seq<char>
    const pathMaxLength :int  := 1024 // Maximum length of a path for UNIX Systems
    const fileMaxLength :int := 50
    const fileMinLength :int := 4
    const fileMaxSize :int32 := 0x79999999 // Maximum file size
    const validFileCharacters := {'-', '_', '.', '(', ')', ' ', '%'}
    const validPathCharacters := {'~','-', '_', '.', '(', ')', ' ', '%', '/'}
    const validStringCharacters := {' ','~','-', '_', '.', '(', ')', ' ', '%', '/', '!', '@', 
    '#', '$', '^', '&', '*', '+', '=', '|', '\\', ':', ';', ',', '?', '<', '>', '[', ']', '{', 
    '}', '\'', ' ', '\t', '\n', '\r'}
    const restricted_commands := [ "rm", "cd", "mv", "cp", "chmod", "chown", "kill", "reboot",
     "shutdown", "mkfs", "mount", "umount", "reboot"]
    const text_extensions := [".txt", ".csv", ".json", ".log", ".md", ".yaml", ".xml"]
    newtype{:nativeType "byte"} byte = i:int | 0 <= i < 0x100
    newtype{:nativeType "int"} int32 = i:int | -0x80000000 <= i < 0x80000000
    newtype{:nativeType "int"} nat32 = i:int | 0 <= i < 0x80000000
    newtype{:nativeType "int"} maxPath = i:int | 0 <= i < 256
    newtype nat64 = i:int | 0 <= i < 0x10000000000000000
    datatype PathOrFile = Path(p: string) | File(f: string)
    // Constants for sensitive paths and files
    const invalidFileTypes :=  ["php", "CON", "PRN", "AUX", "NUL", "COM1", "COM2",
    "COM3", "COM4", "LPT1", "LPT2", "LPT3", "LPT4", "LPT5", "LPT6", "LPT7", "LPT8", "LPT9"]
    const restrictedDirs := [
    "/etc/",
    "/etc/passwd", 
    "/etc/shadow", 
    "/etc/hostname", 
    "/etc/network/interfaces", 
    "/etc/hosts", 
    "/etc/fstab", 
    "/var/log/syslog", 
    "/var/log/auth.log", 
    "/var/log/messages", 
    "/var/log/secure", 
    "/bin/", 
    "/usr/bin/", 
    "/sbin/", 
    "/usr/sbin/", 
    "/lib/", 
    "/lib64/", 
    "/usr/lib/", 
    "/usr/lib64/", 
    "/usr/share/", 
    "/var/www/html", 
    "/boot/", 
    "/proc/", 
    "/sys/", 
    "/etc/ssl/", 
    "/etc/ssh/", 
    "/var/lib/ssl/", 
    "/etc/mysql/", 
    "/etc/postgresql/", 
    "/etc/crontab", 
    "/etc/cron.d/", 
    "/var/spool/cron/", 
    "/var/lib/dpkg/", 
    "/var/lib/rpm/", 
    "/var/cache/apt/", 
    "/var/backups/", 
    "/home/user/backup/", 
    "/root/.ssh/", 
    "/dev/", 
    "/mnt/", 
    "/media/", 
    "/home/user/.bashrc", 
    "/home/user/.profile", 
    "/.ssh/rsa_id"
    ]
    const allowedServices: map<string, seq<string>> := map[
        "apache" := ["access.log", "error.log"],
        "mysql" := ["query.log", "slow.log"],
        "ssh" := ["auth.log"]
        // Add more services and their allowed log files as needed
    ]
    const sensitiveFiles := [
        "/etc/passwd", "/etc/shadow", "/etc/hosts",  // Linux system files
        "C:\\Windows\\System32\\config\\SAM",       // Windows registry
        "C:\\Windows\\System32\\drivers\\etc\\hosts",
        ".ssh/id_rsa", ".ssh/id_rsa.pub",           // SSH private/public keys
        "C:\\ProgramData\\Microsoft\\Windows\\Start Menu"
    ]
    // const SensitiveFilesList : seq<seq<char>> := ["~/id_rsa.pub","/user-data/shared-data.txt",
    // "/user-data/public-info.txt", "/user-data/public-key.txt","shared-data.txt","public-info.txt", 
    // "/company-docs/instructions.txt", "/company-docs/public-info.txt", "/company-docs/employee-handbook.txt", "company-docs/annual-report.txt",
    // "public-key.txt", "safeFile-1.txt", "safeFile-2.txt", "safeFile-3.txt", "bar.txt", "baz.txt"]
    // Set of allowed file extensions
    const allowedExtensionsForRead: seq<string> := ["txt", "pdf", "docx"]
    const allowedExtensionsForWrite: seq<string> := ["txt", "docx"]
    datatype Permission = Read | Write | Execute
    type User = seq<char>

    predicate alpha_numeric(c: char)
    {
        (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || (c >= '0' && c <= '9')
    }

    predicate is_alpha_numeric(s: string)
    {
        forall c :: c in s ==> alpha_numeric(c)
    }

    predicate is_drive_letter(c: char)
    {
        ('a' <= c <= 'z') || ('A' <= c <= 'Z')
    }

    function string_to_int(c: string): seq<int>
    {
        if |c| == 0 then
            []
        else
            seq(|c|, i requires 0 <= i < |c| => c[i] as int)
    }

    predicate is_valid_char(c: char)
    {
        alpha_numeric(c) || c in validPathCharacters

    }

    predicate is_file_valid_char(c: char)
    {
        alpha_numeric(c) || c in validFileCharacters
    }

    predicate is_valid_file_name(filename: string)
    {
        forall i :: 0 <= i < |filename| ==> is_file_valid_char(filename[i])
    }

    predicate is_valid_path_char(c: char)
    {
        alpha_numeric(c) || c in validPathCharacters
    }

    predicate is_valid_path_name(path: string)
    {
        forall i :: 0 <= i < |path| ==> is_valid_char(path[i])
    }

    predicate is_valid_content_str(s: string)
    {
        forall i :: 0 <= i < |s| ==> alpha_numeric(s[i]) || s[i] in validStringCharacters
    }

    predicate is_valid_content_char(c: char)
    {
        alpha_numeric(c) || c in validStringCharacters
    }



    predicate has_valid_file_length(f: file)
    {
        0 < |f| < fileMaxLength
    }

    predicate is_valid_str_length(content: string )
    {
        -0x80000000 <= |string_to_int(content)| < 0x80000000
    }

    predicate has_valid_content_length(content: array<byte>)
    {
    -0x80000000 <= content.Length < 0x80000000
    }

    predicate is_valid_dir_char(c: char)
    {
        alpha_numeric(c) || c in validPathCharacters
    }

    predicate is_valid_dir(p: path)
    {
        forall i :: 0 <= i < |p| ==> is_valid_char(p[i])
    }

    predicate has_valid_path_length(p: path)
    {
      0 <= |p| < pathMaxLength
    }

    predicate non_empty_path(f: file)
    {
        f != "" && |f| > 0
    }

    // Function to check if filename has leading or trailing spaces
    function no_leading_trailing_space(filename: string): bool
    {
       |filename| > 0 && filename[0] != ' ' && filename[|filename|-1] != ' '
    }

    // Function to check if filename starts with a period
    function no_period_at_start(filename: string): bool
    {
        |filename| > 0 && filename[0] != '.'
    }


    function string_slice(s: seq<char>): seq<char>
    {
        if |s| == 0 then "" else ([s[|s| - 1]] + string_slice(s[..(|s| - 1)]))
    }

    lemma StringSliceLemma(s: seq<char>)
    requires 0 <= |s|
    ensures forall i:: 0 <= i < |s| ==> s[..(i+1)] == s[..i] + [s[i]]
    {
    }

    function concat(s1: seq<char>, s2: seq<char>): seq<char>
    {
        s1 + s2
    }

    predicate joint_path_length(p: path, f: file)
    {
        0 < get_path_length(PathOrFile.File(f)) <= fileMaxLength && 0 < get_path_length(PathOrFile.Path(p)) <= pathMaxLength 
        &&  get_path_length(PathOrFile.Path(p)) + get_path_length(PathOrFile.File(f)) <= pathMaxLength
    }

    function append_file_to_path(p: path, f: file): seq<char>
   {
        if |p| == 0 then f else if p[|p| - 1] == '/' then  concat(p, f) else concat(concat(p, "/"), f)
    }


    function get_path_length(pof: PathOrFile): nat
    {
        match pof
        {
            case Path(p) => |p|
            case File(f) => |f|
        }
    }

    predicate has_dangerous_pattern(p: path)
    {
        contains_encoded_periods(p)
        || contains_dangerous_pattern(p)
        || has_dot_dot_slash(p)
        || has_dot_dot_backslash(p)
        || has_slash_dot_dot(p)
        || has_backslash_dot_dot(p)
    }

    predicate has_relative_traversal_pattern(p: path)
    {
        has_parent_dir_traversal(p)
        || has_dot_dot_slash(p)
        || has_dot_dot_backslash(p)
        || has_slash_dot_dot(p)
        || has_backslash_dot_dot(p)
    }

    function get_sep(p: path): string 
    {
        if '/' in p then "/" else "\\"
    }


    function is_abs_path(p: path): bool // retuns true if path has no consecutive periods
    {
        if (get_sep(p) == "/") then is_unix_absolute_path(p) else is_windows_abs_path(p)
    }

    method ContainsAbsolutePaths(p: path) returns (contains: bool)
    requires |p| > 0
    ensures contains <==> is_abs_path(p)
    {
        contains := is_abs_path(p);
    }

    predicate is_unix_absolute_path(p: path)
    {
        |p| > 0 && p[0] == '/'
    }

    predicate is_windows_abs_path(p: path)
    {
        var isDrivePathWithSlash := |p| >= 3 && is_drive_letter(p[0]) && p[1] == ':' &&
                                    (p[2] == '\\' || p[2] == '/');
        var isDrivePath := |p| == 2 && is_drive_letter(p[0]) && p[1] == ':';
        var isUNCPath := |p| >= 2 && p[0] == '\\' && p[1] == '\\';

        (isDrivePathWithSlash || isDrivePath || isUNCPath)
    }

    predicate is_abs(p: path) // similar to python isabs
    {
        is_unix_absolute_path(p) || is_windows_abs_path(p)
    }
    
    method get_file_extension(f: file) returns (extension: string) // Extract and return file extension
    requires |f| > 0
    ensures extension != "" <==> exists i:: 0 <= i < |f| && i+1 < |f| && f[i] == '.' && f[i+1..] == extension
    {
        extension := "";    
        var lastDotIndex := LastCharIndex(f, '.');
        if lastDotIndex == -1 
        {
            return;
        }   
        extension := f[lastDotIndex + 1..];
    }
    
    method ValidateFileType(t: fileType) returns (result: bool)
    requires 0 <= |t| <= 4
    {
        var res := ContainsSequence(restrictedDirs, t);
        result := !res;
    }

    method NonSensitiveFilePath(t: fileType) returns (result: bool)
    requires 0 <= |t| <= 4
    {
        var res := ContainsSequence(restrictedDirs, t);
        if !res {
            result := true;
        } else {
            result := false;
        }
    }

    method ContainsC(s: string, c: char) returns (result: bool)
    requires 'a' <= c <= 'z' || 'A' <= c <= 'Z' || '0' <= c <= '9'
    ensures result ==> (exists i :: 0 <= i < |s| && (s[i] == c)) || c in s
    {
        result := false;
        var i := 0;
        while i < |s|
            invariant 0 <= i <= |s|
            invariant result ==> (exists k :: 0 <= k < i && (s[k] == c))
        {
            if s[i] == c {
            assert c in s;
            result := true;
            break;
            }
            assert result ==> (exists k :: 0 <= k < i && (s[k] == c));
            i := i + 1; 

        }

    }


    predicate is_prefix(p1: path, p2: path)
    {
        |p1| <= |p2| && p1 == p2[..|p1|]
    }

    method ContainsSequence(list: seq<seq<char>>, sub: seq<char>) returns (result: bool)
    ensures result <==> (exists i :: 0 <= i < |list| && sub == list[i])
    {
        result := false;
        if |list| == 0
        {
            return;
        }  
        var i := 0;
        while i < |list|
            invariant 0 <= i <= |list|
            invariant result <==> (exists k :: 0 <= k < i && sub == list[k])
            decreases |list| - i
        {
            if sub == list[i] {
            result := true;
            return;
            }
            i := i + 1;
        }
    }

    predicate is_lower_case(c : char)
    {
        'a' <= c <= 'z'
    }

    predicate is_lower_upper_pair(c : char, C : char)
    {
        (c as int) == (C as int) + 32
    }

    function shift_minus32(c : char) :  char
    {
        ((c as int - 32) % 128) as char
    }

    method ToUppercase(s: string) returns (v: string)
        ensures |v| == |s|
        ensures forall i :: 0 <= i < |s| ==>  if is_lower_case(s[i]) then is_lower_upper_pair(s[i], v[i]) else v[i] == s[i]
    {
        var s' : string := [];
        for i := 0 to |s|
        invariant 0 <= i <= |s|
        invariant |s'| == i
        invariant forall k :: 0 <= k < i &&  is_lower_case(s[k]) ==> is_lower_upper_pair(s[k], s'[k])
        invariant forall k :: 0 <= k < i && !is_lower_case(s[k]) ==> s[k] == s'[k]
        {
            if is_lower_case(s[i])
            {
                s' := s' + [shift_minus32(s[i])];
            }
            else 
            {
                s' := s' + [s[i]];
            }
        }
        return s';
    }


    method ArrayFromSeq<A>(s: seq<A>) returns (a: array<A>)
    // Convert a string to an array of characters
    ensures a[..] == s
    {
    a := new A[|s|] ( i requires 0 <= i < |s| => s[i] );
    }

    function digit_to_char(n: nat): char
    {   
        if (n < 10) then '0' + n as char else '0'
    }

    function number_to_string(n: nat): string
    {
        if n < 10 then [digit_to_char(n)] else number_to_string(n/10) + [digit_to_char(n % 10)]
    }


    function char_to_int(c: char): int 
    // Convert a character to a byte
    {
        c as int
    }

    function char_to_byte(c: char): byte
    // Convert a character to a byte
    {
        var i := char_to_int(c);
        if 0 <= i < 0x100 then i as byte else 0 as byte
    }

    method StringToSeqInt(s: string) returns (bytesSeq: seq<int>)
    // Convert a string to a sequence of bytes<int>
    requires |s| > 0
    ensures |s| == |bytesSeq| 
    ensures forall i: int :: 0 <= i < |s| ==> bytesSeq[i] == s[i] as int  
    {
    bytesSeq := [];
    var i := 0;
    while i < |s|
        invariant 0 <= i <= |s|
        invariant |bytesSeq| == i 
        invariant forall j: int :: 0 <= j < i ==> bytesSeq[j] == s[j] as int  
    {
        bytesSeq := bytesSeq + [char_to_int(s[i])];
        i := i + 1;
    }

    }

    function list_contains_string(list: seq<seq<char>>, sub: seq<char>): bool
    ensures list_contains_string(list, sub) <==> (exists i :: 0 <= i < |list| && sub == list[i])
    {
    if |list| == 0 then
        false
    else if sub == list[0] then
        true
    else
        list_contains_string(list[1..], sub)
    }

    predicate ContainsChar(s: string, c: char)
    {
        c in s
    }

    lemma CharAtIndexImpliesContainsC(s: string, c: char, index: int)
    requires 'a' <= c <= 'z' || 'A' <= c <= 'Z' || '0' <= c <= '9'
    requires 0 <= index < |s|
    requires s[index] == c
    ensures ContainsChar(s, c)
    {
    }



    //Path is not empty
    predicate non_empty_string(s: string)
    {
        |s| > 0 && s != ""
    }

    //Path does not contain reserved names
    method HasNoReservedNames(path: string) returns (isValid: bool)
    requires |path| > 0
    {
    var reservedNames := ["CON", "PRN", "AUX", "NUL", "COM1", "COM2", "COM3", "COM4", "LPT1", "LPT2", "LPT3", "LPT4"];
    var upperPath := ToUppercase(path);
    for i := 0 to |reservedNames|
    {
        var startsWithReserved := StartsWith(upperPath, reservedNames[i]+ ".");
        if upperPath == reservedNames[i] || startsWithReserved {
        return false;
        }
    }
    return true;
    }


    //A given string starts with prefix
    method StartsWith(s: string, prefix: string) returns (result: bool)
    requires |prefix| > 0
    requires |s| > 0
    ensures result ==> |s| >= |prefix| && s[..|prefix|] == prefix
    {
        if |s| < |prefix| {
            return false;
        } else {
            return s[..|prefix|] == prefix;
        }
    }

    function has_dot_dot_slash(path: seq<char>): bool
    decreases |path|
    {
        if |path| < 3 then
            false
        else
            (path[0] == '.' && path[1] == '.' && path[2] == '/')
            || has_dot_dot_slash(path[1..])
    }

    method ContainsDotDotForwardSlash(path: seq<char>) returns (contains: bool)
    ensures contains <==> has_dot_dot_slash(path)
    {
        contains := has_dot_dot_slash(path);
    }

    function has_dot_dot_backslash(path: seq<char>): bool
    decreases |path|
    {
        StringSliceLemma(path);
        if |path| < 3 then
            false
        else
            (path[0] == '.' && path[1] == '.' && path[2] == '\\')
            || has_dot_dot_backslash(path[1..])
    }

    method ContainsDotDotBackslash(path: seq<char>) returns (contains: bool)
    ensures contains <==> has_dot_dot_backslash(path)
    {
        contains := has_dot_dot_backslash(path);
    }

    function has_slash_dot_dot(path: seq<char>): bool
    decreases |path|
    {
        StringSliceLemma(path);
        if |path| < 3 then
            false
        else
            (path[0] == '/' && path[1] == '.' && path[2] == '.')
            || has_slash_dot_dot(path[1..])
    }

    method ContainsSlashDotDot(path: seq<char>) returns (contains: bool)
    ensures contains <==> has_slash_dot_dot(path)
    {
        contains := has_slash_dot_dot(path);
    }


    function has_backslash_dot_dot(path: seq<char>): bool
    decreases |path|
    {
        StringSliceLemma(path);
        if |path| < 3 then
            false
        else
            (path[0] == '\\' && path[1] == '.' && path[2] == '.')
            || has_backslash_dot_dot(path[1..])
    }

    method ContainsBackslashDotDot(path: seq<char>) returns (contains: bool)
    requires |path| > 0
    ensures contains <==> has_backslash_dot_dot(path)
    {
        contains := has_backslash_dot_dot(path);
    }


    predicate contains_encoded_periods(s: seq<char>)
    decreases s
    {
        if |s| < 4 then
            false
        else if s[0] == '%' && s[1] == '2' && s[2] == 'e' && s[3] == 'e' then
            true
        else
            contains_encoded_periods(s[1..])

    }



    // Check for parent directory traversal (..)
    predicate has_parent_dir_traversal(s: seq<char>)
    decreases s
    {
        if |s| < 2 then
            false
        else if s[0] == '.' && s[1] == '.' then
            true
        else
            has_parent_dir_traversal(s[1..])
    }

    // Check for home directory reference (~)
    predicate has_home_dir_reference(s: seq<char>)
        decreases s
    {
        StringSliceLemma(s);
        if |s| < 1 then
            false
        else if s[0] == '~' then
            true
        else
            has_home_dir_reference(s[1..])
    }

    function has_consecutive_dots(path: string): bool
    decreases |path|
    {
    if |path| < 2 then
        false
    else
        (path[0] == '.' && path[1] == '.')
        || has_consecutive_dots(path[1..])
    }


    // Check for drive letter (contains :)
    predicate contains_drive_letter(s: seq<char>)
        decreases s
    {
        StringSliceLemma(s);
        if |s| < 1 then
            false
        else if s[0] == ':' then
            true
        else
            contains_drive_letter(s[1..])
    }

    // Main function to detect dangerous patterns
    predicate contains_dangerous_pattern(s: seq<char>)
    {
        has_parent_dir_traversal(s) ||
        has_home_dir_reference(s) ||
        // StartsWithAbsolutePath(s) ||
        contains_drive_letter(s)
    }

    predicate base_includes_path (filePath: seq<char>, base: seq<char>)
    {
        |filePath| >= |base| && filePath[..|base|] == base
    }

    method SplitPath(path: string) returns (head: string, tail: string)
    ensures |path| == 0 ==> head == "" && tail == ""
    ensures (forall i:: 0 <= i < |path| ==> path[i] != '/') ==> head == "" && tail == path
    ensures path == head + tail
    ensures head != "" && tail != "" ==> head == path[..|head|] && tail == path[|head|..]
    ensures |head| == (|path| - 1) && tail == "" ==> head == path[..|path|-1] && tail == path[|head|..]
    {
        var slashIdx := LastSlash(path);
        if slashIdx == -1 {
            head, tail := "", path;  // No slash found    
        } 
        head, tail := path[..slashIdx + 1], path[slashIdx + 1..];  
        StringSliceLemma(path);
        assert path == head + tail;
        print "head", "\n", head, "\n";
        print "tail", "\n", tail, "\n";
    }


    method LastSlash(s: string) returns (idx: int)
    ensures -1 <= idx < |s|
    ensures idx == -1 ==> (forall i:: 0 <= i < |s| ==> s[i] != '/')
    ensures s == s[..idx+1] + s[idx+1..]
    ensures idx != -1 ==> (forall i :: idx < i < |s| ==> s[i] != '/') && s[idx] == '/'
    ensures |s| > 0 && s[|s|-1] == '/' ==> idx == |s|-1
    ensures s == "/" ==> idx == 0
    {
        idx := -1;
        var i := |s| - 1;
        while i >= 0
            decreases i
            invariant -1 <= i < |s|
            invariant idx != -1 ==> s[idx] == '/' &&  (forall i :: idx < i < |s| ==> s[i] != '/')
            invariant (idx == -1 ==> (forall j :: i < j < |s| ==> s[j] != '/'))
        {
            if s[i] == '/' {
                idx := i;
                assert i == idx;
                assert s[idx] == '/';
                print "\n", "Input", "\n", s;
                print "\n", "Last slash index @", "\n", idx;
                print "\n", "---------------", "\n";
                assert if s == "/" then idx == 0 else idx == i;
                break;
            }
            assert s[i] != '/';
            assert idx != i;
            i := i - 1;
        }
        StringSliceLemma(s);
        assert idx == -1 || (0 <= idx < |s| && s[idx] == '/');
    }

    method SplitAll(path: string) returns (parts: seq<string>)
    ensures path == "/" ==> parts == []
    ensures |path| == 0 ==> parts == []
    ensures path != "/" && |path| > 0 && path[0] == '/' ==> (forall p :: p in parts ==> |p| > 0)
    decreases |path|
    {
        if |path| == 0 || path == "/" {
            return [];
        }
        var head, tail := SplitPath(path);
        
        if head == "" && tail == "" {
            return []; 
        } else if head == "" && tail != "" {
            return [tail]; 
        }  else if head == path {
            parts := SplitAll(path[..|path| - 1]);
        } else {
            var firstPart := tail;
            var remainingParts := SplitAll(head[..|head|-1]);

            if |firstPart| > 0 {
                return remainingParts + [firstPart];
            } else {
                return remainingParts;
            }
        }
    }

    method SplitAllWithSlashes(path: string) returns (parts: seq<string>)
    ensures path == "/" ==> parts == ["/"]
    ensures |path| == 0 ==> parts == []
    ensures forall p :: p in parts ==> |p| > 0
    decreases |path| 
    {
        if |path| == 0 {
            return [];
            return;
        } else if path == "/" {
            return ["/"];
        }

        var head, tail := SplitPath(path);

        if head == "" {
            if |tail| > 0 {
                return [tail];
            } else {
                return [];  
            }
        }

        var firstPart := tail;
        var remainingParts := SplitAllWithSlashes(head[..|head|-1]);
        if |firstPart| > 0 {
            return remainingParts + ["/"] + [firstPart];
        } else {
            return  remainingParts;
        }
    }

     //This method should return true iff pre is a prefix of str. That is, str starts with pre
    method IsPrefix(pre:string, str:string) returns(res:bool)
        requires 0 < |pre| <= |str|
    {

        var i := 0;


        while (i < |pre|)
            invariant 0 <= i <= |pre|   
            decreases |pre| - i        
        {
            if (str[i] != pre[i]) {
                print str[i], " != ", pre[i], "\n";
                return false;
            }
            else{
                print str[i], " == ", pre[i], "\n";

                i := i + 1;
            }
        }
        return true;
    }

    //This method should return true iff sub is a substring of str. That is, str contains sub
    method IsSubstring(sub:string, str:string) returns(res:bool)
        requires 0 < |sub| <= |str|
    {

        var i := 0;
        var n := (|str| - |sub|);

            while(i < n+1)
            invariant 0 <= i <= n+1   
            decreases n - i         
        {
            print "\n", sub, ", ", str[i..|str|], "\n";

            var result:= IsPrefix(sub, str[i..|str|]);
            if(result == true){
                return true;
            }
            else{
                i := i+1;
            }
        }
        return false;
    }

    //This method should return true iff str1 and str1 have a common substring of length k
    method HaveCommonKSubstring(k:nat, str1:string, str2:string) returns(found:bool)
        requires 0 < k <= |str1| &&  0 < k <= |str2|
    {
        var i := 0;
        var n := |str1|-k;
        while(i < n)
            decreases n - i
        {
            print "\n", str1[i..i+k], ", ", str2, "\n";

            var result := IsSubstring(str1[i..i+k], str2);
            if(result == true){
                return true;
            }
            else{
                i:=i+1;
            }
        }
        return false;
    }

    //This method should return the natural number len which is equal to the length of the longest common substring of str1 and str2. Note that every two strings have a common substring of length zero.
    method MaxCommonSubstringLength(str1:string, str2:string) returns(len:nat)
        requires 0 < |str1| && 0 < |str1|
    {
        var result:bool;
        var i:= |str1|;
        if(|str2| < |str1|){
            i := |str2|;
        }

        while (i > 0)
            decreases i - 0
        {
            print str1, ", ", str2, " k = ", i, "\n";
            
            result := HaveCommonKSubstring(i, str1, str2);

            if(result == true){
                return i;
            }
            else{
                i := i - 1;
            }
        }
        return 0;
    }

    method LastCharIndex(s: string, c: char) returns (idx: int)
    ensures -1 <= idx < |s|
    ensures idx == -1 ==> (forall i:: 0 <= i < |s| ==> s[i] != c)
    ensures 0 <= idx < |s| ==> s[idx] == c
    ensures idx != -1 ==> (forall i :: idx < i < |s| ==> s[i] != c)
    {
        idx := -1;
        var i := |s| - 1;
        while i >= 0
            decreases i
            invariant -1 <= i < |s|
            invariant idx != -1 ==> s[idx] == c &&  (forall i :: idx < i < |s| ==> s[i] != c)
            invariant (idx == -1 ==> (forall j :: i < j < |s| ==> s[j] != c))
        {
            if s[i] == c {
                idx := i;
                assert i == idx;
                assert s[idx] == c;
                print "Input", "\n", s;
                print "Last slash index @", "\n", idx;
                print "---------------", "\n";
                break;
            }
            assert s[i] != c;
            assert idx != i;
            i := i - 1;
        }
        assert idx == -1 || (0 <= idx < |s| && s[idx] == c);
    }

    predicate access_to_private_key(p: path)
    {
        |p| > 5 && p[|p|-4..] != ".pub"
    }

    predicate forbidden_dir_access(p: path)
    {
        p in restrictedDirs
    }

    predicate extract_file_type(e: extension, requestedType: string)
    {
        e == requestedType
    }

    method UnsanitizeFileContent(s: string) returns (restrictedCommand: bool)
    requires forall i :: 0 <= i < |restricted_commands| ==> |restricted_commands[i]| <= |s| 
    {
        restrictedCommand := false;
        var i := 0;
        while i < |restricted_commands|
            invariant 0 <= i <= |restricted_commands|
            invariant restrictedCommand ==> forall j :: 0 <= j < i ==> |restricted_commands[j]| <= |s| && restricted_commands[j] != s[..|restricted_commands[j]|]
        {
            print restricted_commands[i], "\n";
            print s[..|restricted_commands[i]|], "\n";
          restrictedCommand := IsSubstring(restricted_commands[i], s);
          print restrictedCommand, "\n";
          if restrictedCommand {
              return;
          }
          i := i + 1;
        }  
    }

}