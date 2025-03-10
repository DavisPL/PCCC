include "../../std/utils/OsPath.dfy"
method Main()
{
    // // Test Case 1: Path with a single slash
    var path := "/home/user/";
    var res := LastSlash(path);
    assert path [10] == '/';
    // assert (-1 <= res < |path|);
    assert res == 10;
    expect res == 10, "first failed";

    // Test Case 2: Path with no slashes
    path := "homeuser";
    res := LastSlash(path);
    assert res == -1;

    // Test Case 3: Path with multiple slashes
    path := "/home/user/docs/";
    res := LastSlash(path);
    assert 1 == 1;
    assert path[15] == '/';
    assert res == 15;
    expect res == 15, "/home/user/docs/"; // Index of the last '/'

    // Test Case 4: Path with a trailing slash
    path := "home/user/";
    res := LastSlash(path);
    assert path[9] == '/';
    expect res == 9, "home/user/"; // Index of the last '/'

    // Test Case 5: Path with slashes at the beginning and end
    path := "/home/user/";
    res := LastSlash(path);
    assert path[10] == '/';
    assert res == 10;
    expect res == 10, "/home/user/"; // Index of the last '/'


    // Test Case 7: Empty path (should not be valid with the current precondition)
    path := "";
    res := LastSlash(path);
    assert res == -1;

    // Edge Case 1: Path with exactly one character (not a slash)
    path := "a";
    res := LastSlash(path);
    assert res == -1;

    // Edge Case 2: Path with exactly one character (a slash)
    path := "/";
    res := LastSlash(path);
    assert path[0] == '/';
    assert res == 0;

    // Edge Case 3: Path with slashes and other characters
    path := "/abc/xyz/";
    res := LastSlash(path);
    assert path[8] == '/';
    assert res == 8;
    expect res == 8 , "Last not found"; // Index of the last '/'
}