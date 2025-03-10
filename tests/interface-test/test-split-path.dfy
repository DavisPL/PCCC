include "../../std/utils/OsPath.dfy"

method Test1() {
    var path := "/home/user/Desktop/file.txt";
    var head, tail := SplitPath(path);
    assert path [18] == '/';
    var res := LastSlash(path);
    assert res == 18;
    assert path[0] == '/';
    assert path [1] == 'h';
    assert path [0..19] == "/home/user/Desktop/";
    assert path [19..] == "file.txt";
    assert path == path [0..19] + path [19..];
    assert res + 1 == 19;
    var s1 := "/home/user/Desktop/";
    assert s1 == path[0..19];
    // assert head == s1;
    // assert head == path[0..19];  // might not hold
    // assert head == "/home/user/Desktop/";  // might not hold
    expect head == "/home/user/Desktop/", "h1";
    expect tail == "file.txt", "t1";
}

method Test2() {
    var path := "/home/user/Desktop/";
    var head, tail := SplitPath(path);
    assert path [18] == '/';
    var res := LastSlash(path);
    assert res == 18;
    expect head == "/home/user/Desktop/", "h2";
    expect tail == "", "t2";
}

method Test3() {
    var path := "file.txt";
    var head, tail := SplitPath(path);
    var res := LastSlash(path);
    assert res == -1;
    assert head == "";
    assert tail == "file.txt";
    expect head == "", "h3";
    expect tail == "file.txt", "t3";
}

method Test4() {
    var path := "";
    var head, tail := SplitPath(path);
    var res := LastSlash(path);
    assert res == -1;
    assert head == "";
    assert tail == "";
    expect head == "", "h4";
    expect tail == "", "t4";
}

method Test5() {
    var path := "folder";
    var head, tail := SplitPath(path);
    var res := LastSlash(path);
    assert res == -1;
    assert head == "";
    assert tail == "folder";
    expect head == "", "h5";
    expect tail == "folder", "t5";
}

method Test6() {
    var path := "folder/";
    var head, tail := SplitPath(path);
    assert path[6] == '/';
    var res := LastSlash(path);
    assert res == 6;
    assert path [0..7] == "folder/";
    // assert head == path [0..7];
    // assert head != "";
    // assert head == "folder/";
    // assert tail == "";
    expect head == "folder/", "h6";
    expect tail == "", "t6";
}

method Test7() {
    var path := "home";
    var head, tail := SplitPath(path);
    var res := LastSlash(path);
    assert res == -1;
    assert head == "";
    assert tail == "home";
    expect head == "", "h7";
    expect tail == "home", "t7";
}

method Test8() {
    var path := "/a/b/c/d/e/f";
    var head, tail := SplitPath(path);
    var res := LastSlash(path);
    assert path[10] == '/';
    assert res == 10;
    // assert head == "/a/b/c/d/e/"; // might not hold because Dafny does not about the value of path
    // assert tail == "f";
    expect head == "/a/b/c/d/e/", "h8";
    expect tail == "f", "t8";
}

method Test9() {
    var path := "/";
    var head, tail := SplitPath(path);
    assert path[0] == '/';
    var res := LastSlash(path);
    assert res == 0;
    // assert head == "/";
    // assert tail == "";
    expect head == "/", "h9";
    expect tail == "", "t9";
}

method Test10() {
    var path := "/home/user/special_file.txt";
    var head, tail := SplitPath(path);
    assert path[10] == '/';
    var res := LastSlash(path);
    assert res == 10;
    expect head == "/home/user/", "h10";
    expect tail == "special_file.txt", "t10";
}

method TestSplitAll() {
    print "Testing SplitAll...\n";

    var result1 := SplitAll("/usr/bin/bash/");
    print "Input: /usr/bin/bash/ -> ", result1, "\n";
    expect result1 == ["usr", "bin", "bash"];

    var result2 := SplitAll("/home/user/docs/");
    print "Input: /home/user/docs/ -> ", result2, "\n";
    expect result2 == ["home", "user", "docs"];

    var result3 := SplitAll("home/user/");
    print "Input: home/user/ -> ", result3, "\n";
    expect result3 == ["home", "user"];

    var result4 := SplitAll("/");
    print "Input: / -> ", result4, "\n";
    assert result4 == [];

    var result5 := SplitAll("///");
    print "Input: /// -> ", result5, "\n";
    expect result5 == [];

    var result6 := SplitAll("/a//b//c/");
    print "Input: /a//b//c/ -> ", result6, "\n";
    expect result6 == ["a", "b", "c"];

    var result7 := SplitAll("/a//b/../c/");
    print "Input: /a//b/../c/ -> ", result7, "\n";
    expect result7 == ["a", "b","..", "c"];

    var result8 := SplitAll("home/user/file.txt");
    print "Input: home/user/file.txt -> ", result8, "\n";
    expect result8 == ["home", "user", "file.txt"];

    print "All tests passed!\n";
}

method TestSplitAllWithSlashes() {
    print "Testing SplitAllWithSlashes...\n";

    var result1 := SplitAllWithSlashes("/usr/bin/bash/");
    print "Input: /usr/bin/bash/ -> ", result1, "\n";
    expect result1 == ["/", "usr", "/", "bin", "/", "bash", "/"];

    var result2 := SplitAllWithSlashes("/home/user/docs/");
    print "Input: /home/user/docs/ -> ", result2, "\n";
    expect result2 == ["/", "home", "/", "user", "/", "docs", "/"];

    var result3 := SplitAllWithSlashes("home/user/");
    print "Input: home/user/ -> ", result3, "\n";
    expect result3 == ["home", "/", "user", "/"];

    var result4 := SplitAllWithSlashes("/");
    print "Input: / -> ", result4, "\n";
    expect result4 == ["/"];

    var result5 := SplitAllWithSlashes("///");
    print "Input: /// -> ", result5, "\n";
    expect result5 == ["/", "/", "/"];

    var result6 := SplitAllWithSlashes("/a//b//c/");
    print "Input: /a//b//c/ -> ", result6, "\n";
    expect result6 == ["/", "a", "/", "/", "b", "/", "/", "c", "/"];

    print "All tests for split with slashes passed!\n";
}





method Main() {
    Test1();
    Test2();
    Test3();
    Test4();
    Test5();
    Test6();
    Test7();
    Test8();
    Test9();
    Test10();
    TestSplitAll();
    TestSplitAllWithSlashes();
    var s := "hello";
    var s2 := "hello";
    assert s == s2;
    assert s[0] == 'h';
    assert s[0..2] == "he";
}