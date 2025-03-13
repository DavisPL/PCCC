import sys
from typing import Callable, Any, TypeVar, NamedTuple
from math import floor
from itertools import count

import module_ as module_
import _dafny as _dafny
import System_ as System_

# Module: module_

class default__:
    def  __init__(self):
        pass

    @staticmethod
    def Test1():
        d_0_path_: _dafny.Seq
        d_0_path_ = _dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "/home/user/Desktop/file.txt"))
        d_1_head_: _dafny.Seq
        d_2_tail_: _dafny.Seq
        out0_: _dafny.Seq
        out1_: _dafny.Seq
        out0_, out1_ = default__.SplitPath(d_0_path_)
        d_1_head_ = out0_
        d_2_tail_ = out1_
        d_3_res_: int
        out2_: int
        out2_ = default__.LastSlash(d_0_path_)
        d_3_res_ = out2_
        if not((d_1_head_) == (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "/home/user/Desktop/")))):
            raise _dafny.HaltException("test-split-path.dfy(12,4): " + (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "h1"))).VerbatimString(False))
        if not((d_2_tail_) == (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "file.txt")))):
            raise _dafny.HaltException("test-split-path.dfy(13,4): " + (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "t1"))).VerbatimString(False))

    @staticmethod
    def Test2():
        d_0_path_: _dafny.Seq
        d_0_path_ = _dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "/home/user/Desktop/"))
        d_1_head_: _dafny.Seq
        d_2_tail_: _dafny.Seq
        out0_: _dafny.Seq
        out1_: _dafny.Seq
        out0_, out1_ = default__.SplitPath(d_0_path_)
        d_1_head_ = out0_
        d_2_tail_ = out1_
        d_3_res_: int
        out2_: int
        out2_ = default__.LastSlash(d_0_path_)
        d_3_res_ = out2_
        if not((d_1_head_) == (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "/home/user/Desktop/")))):
            raise _dafny.HaltException("test-split-path.dfy(22,4): " + (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "h2"))).VerbatimString(False))
        if not((d_2_tail_) == (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "")))):
            raise _dafny.HaltException("test-split-path.dfy(23,4): " + (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "t2"))).VerbatimString(False))

    @staticmethod
    def Test3():
        d_0_path_: _dafny.Seq
        d_0_path_ = _dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "file.txt"))
        d_1_head_: _dafny.Seq
        d_2_tail_: _dafny.Seq
        out0_: _dafny.Seq
        out1_: _dafny.Seq
        out0_, out1_ = default__.SplitPath(d_0_path_)
        d_1_head_ = out0_
        d_2_tail_ = out1_
        d_3_res_: int
        out2_: int
        out2_ = default__.LastSlash(d_0_path_)
        d_3_res_ = out2_
        if not((d_1_head_) == (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "")))):
            raise _dafny.HaltException("test-split-path.dfy(31,4): " + (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "h3"))).VerbatimString(False))
        if not((d_2_tail_) == (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "file.txt")))):
            raise _dafny.HaltException("test-split-path.dfy(32,4): " + (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "t3"))).VerbatimString(False))

    @staticmethod
    def Test4():
        d_0_path_: _dafny.Seq
        d_0_path_ = _dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, ""))
        d_1_head_: _dafny.Seq
        d_2_tail_: _dafny.Seq
        out0_: _dafny.Seq
        out1_: _dafny.Seq
        out0_, out1_ = default__.SplitPath(d_0_path_)
        d_1_head_ = out0_
        d_2_tail_ = out1_
        d_3_res_: int
        out2_: int
        out2_ = default__.LastSlash(d_0_path_)
        d_3_res_ = out2_
        if not((d_1_head_) == (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "")))):
            raise _dafny.HaltException("test-split-path.dfy(40,4): " + (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "h4"))).VerbatimString(False))
        if not((d_2_tail_) == (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "")))):
            raise _dafny.HaltException("test-split-path.dfy(41,4): " + (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "t4"))).VerbatimString(False))

    @staticmethod
    def Test5():
        d_0_path_: _dafny.Seq
        d_0_path_ = _dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "folder"))
        d_1_head_: _dafny.Seq
        d_2_tail_: _dafny.Seq
        out0_: _dafny.Seq
        out1_: _dafny.Seq
        out0_, out1_ = default__.SplitPath(d_0_path_)
        d_1_head_ = out0_
        d_2_tail_ = out1_
        d_3_res_: int
        out2_: int
        out2_ = default__.LastSlash(d_0_path_)
        d_3_res_ = out2_
        if not((d_1_head_) == (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "")))):
            raise _dafny.HaltException("test-split-path.dfy(49,4): " + (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "h5"))).VerbatimString(False))
        if not((d_2_tail_) == (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "folder")))):
            raise _dafny.HaltException("test-split-path.dfy(50,4): " + (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "t5"))).VerbatimString(False))

    @staticmethod
    def Test6():
        d_0_path_: _dafny.Seq
        d_0_path_ = _dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "folder/"))
        d_1_head_: _dafny.Seq
        d_2_tail_: _dafny.Seq
        out0_: _dafny.Seq
        out1_: _dafny.Seq
        out0_, out1_ = default__.SplitPath(d_0_path_)
        d_1_head_ = out0_
        d_2_tail_ = out1_
        d_3_res_: int
        out2_: int
        out2_ = default__.LastSlash(d_0_path_)
        d_3_res_ = out2_
        if not((d_1_head_) == (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "folder/")))):
            raise _dafny.HaltException("test-split-path.dfy(59,4): " + (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "h6"))).VerbatimString(False))
        if not((d_2_tail_) == (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "")))):
            raise _dafny.HaltException("test-split-path.dfy(60,4): " + (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "t6"))).VerbatimString(False))

    @staticmethod
    def Test7():
        d_0_path_: _dafny.Seq
        d_0_path_ = _dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "home"))
        d_1_head_: _dafny.Seq
        d_2_tail_: _dafny.Seq
        out0_: _dafny.Seq
        out1_: _dafny.Seq
        out0_, out1_ = default__.SplitPath(d_0_path_)
        d_1_head_ = out0_
        d_2_tail_ = out1_
        d_3_res_: int
        out2_: int
        out2_ = default__.LastSlash(d_0_path_)
        d_3_res_ = out2_
        if not((d_1_head_) == (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "")))):
            raise _dafny.HaltException("test-split-path.dfy(68,4): " + (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "h7"))).VerbatimString(False))
        if not((d_2_tail_) == (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "home")))):
            raise _dafny.HaltException("test-split-path.dfy(69,4): " + (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "t7"))).VerbatimString(False))

    @staticmethod
    def Test8():
        d_0_path_: _dafny.Seq
        d_0_path_ = _dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "/a/b/c/d/e/f"))
        d_1_head_: _dafny.Seq
        d_2_tail_: _dafny.Seq
        out0_: _dafny.Seq
        out1_: _dafny.Seq
        out0_, out1_ = default__.SplitPath(d_0_path_)
        d_1_head_ = out0_
        d_2_tail_ = out1_
        d_3_res_: int
        out2_: int
        out2_ = default__.LastSlash(d_0_path_)
        d_3_res_ = out2_
        if not((d_1_head_) == (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "/a/b/c/d/e/")))):
            raise _dafny.HaltException("test-split-path.dfy(78,4): " + (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "h8"))).VerbatimString(False))
        if not((d_2_tail_) == (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "f")))):
            raise _dafny.HaltException("test-split-path.dfy(79,4): " + (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "t8"))).VerbatimString(False))

    @staticmethod
    def Test9():
        d_0_path_: _dafny.Seq
        d_0_path_ = _dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "/"))
        d_1_head_: _dafny.Seq
        d_2_tail_: _dafny.Seq
        out0_: _dafny.Seq
        out1_: _dafny.Seq
        out0_, out1_ = default__.SplitPath(d_0_path_)
        d_1_head_ = out0_
        d_2_tail_ = out1_
        d_3_res_: int
        out2_: int
        out2_ = default__.LastSlash(d_0_path_)
        d_3_res_ = out2_
        if not((d_1_head_) == (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "/")))):
            raise _dafny.HaltException("test-split-path.dfy(88,4): " + (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "h9"))).VerbatimString(False))
        if not((d_2_tail_) == (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "")))):
            raise _dafny.HaltException("test-split-path.dfy(89,4): " + (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "t9"))).VerbatimString(False))

    @staticmethod
    def Test10():
        d_0_path_: _dafny.Seq
        d_0_path_ = _dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "/home/user/special_file.txt"))
        d_1_head_: _dafny.Seq
        d_2_tail_: _dafny.Seq
        out0_: _dafny.Seq
        out1_: _dafny.Seq
        out0_, out1_ = default__.SplitPath(d_0_path_)
        d_1_head_ = out0_
        d_2_tail_ = out1_
        d_3_res_: int
        out2_: int
        out2_ = default__.LastSlash(d_0_path_)
        d_3_res_ = out2_
        if not((d_1_head_) == (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "/home/user/")))):
            raise _dafny.HaltException("test-split-path.dfy(98,4): " + (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "h10"))).VerbatimString(False))
        if not((d_2_tail_) == (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "special_file.txt")))):
            raise _dafny.HaltException("test-split-path.dfy(99,4): " + (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "t10"))).VerbatimString(False))

    @staticmethod
    def Main(noArgsParameter__):
        default__.Test1()
        default__.Test2()
        default__.Test3()
        default__.Test4()
        default__.Test5()
        default__.Test6()
        default__.Test7()
        default__.Test8()
        default__.Test9()
        default__.Test10()

    @staticmethod
    def SplitPath(path):
        head: _dafny.Seq = _dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, ""))
        tail: _dafny.Seq = _dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, ""))
        d_0_slashIdx_: int
        out0_: int
        out0_ = default__.LastSlash(path)
        d_0_slashIdx_ = out0_
        if (len(path)) == (0):
            rhs0_ = _dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, ""))
            rhs1_ = _dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, ""))
            head = rhs0_
            tail = rhs1_
        elif (d_0_slashIdx_) == (-1):
            rhs2_ = _dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, ""))
            rhs3_ = path
            head = rhs2_
            tail = rhs3_
        elif (d_0_slashIdx_) == ((len(path)) - (1)):
            rhs4_ = path
            rhs5_ = _dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, ""))
            head = rhs4_
            tail = rhs5_
        elif True:
            rhs6_ = _dafny.SeqWithoutIsStrInference((path)[:(d_0_slashIdx_) + (1):])
            rhs7_ = _dafny.SeqWithoutIsStrInference((path)[(d_0_slashIdx_) + (1)::])
            head = rhs6_
            tail = rhs7_
        _dafny.print((_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "head"))).VerbatimString(False))
        _dafny.print((_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "\n"))).VerbatimString(False))
        _dafny.print((head).VerbatimString(False))
        _dafny.print((_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "\n"))).VerbatimString(False))
        _dafny.print((_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "tail"))).VerbatimString(False))
        _dafny.print((_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "\n"))).VerbatimString(False))
        _dafny.print((tail).VerbatimString(False))
        _dafny.print((_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "\n"))).VerbatimString(False))
        return head, tail

    @staticmethod
    def LastSlash(s):
        idx: int = int(0)
        idx = -1
        d_0_i_: int
        d_0_i_ = (len(s)) - (1)
        with _dafny.label("0"):
            while (d_0_i_) >= (0):
                with _dafny.c_label("0"):
                    if ((s)[d_0_i_]) == (_dafny.CodePoint('/')):
                        idx = d_0_i_
                        _dafny.print((_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "\n"))).VerbatimString(False))
                        _dafny.print((_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "Input"))).VerbatimString(False))
                        _dafny.print((_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "\n"))).VerbatimString(False))
                        _dafny.print((s).VerbatimString(False))
                        _dafny.print((_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "\n"))).VerbatimString(False))
                        _dafny.print((_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "Last slash index @"))).VerbatimString(False))
                        _dafny.print((_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "\n"))).VerbatimString(False))
                        _dafny.print(_dafny.string_of(idx))
                        _dafny.print((_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "\n"))).VerbatimString(False))
                        _dafny.print((_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "---------------"))).VerbatimString(False))
                        _dafny.print((_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "\n"))).VerbatimString(False))
                        raise _dafny.Break("0")
                    d_0_i_ = (d_0_i_) - (1)
                    pass
            pass
        return idx

    @staticmethod
    def AbsPath(c):
        pass
        pass

