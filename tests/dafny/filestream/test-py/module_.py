import sys
from typing import Callable, Any, TypeVar, NamedTuple
from math import floor
from itertools import count

import module_
import _dafny
import System_

# Module: module_

class default__:
    def  __init__(self):
        pass

    @staticmethod
    def ArrayFromSeq(s):
        a: _dafny.Array = _dafny.Array(None, 0)
        def lambda0_(d_0_s_):
            def lambda1_(d_1_i_):
                return (d_0_s_)[d_1_i_]

            return lambda1_

        init0_ = lambda0_(s)
        nw0_ = _dafny.Array(None, len(s))
        for i0_0_ in range(nw0_.length(0)):
            nw0_[i0_0_] = init0_(i0_0_)
        a = nw0_
        return a

    @staticmethod
    def Main(noArgsParameter__):
        d_2_fname_: _dafny.Array
        out0_: _dafny.Array
        out0_ = default__.ArrayFromSeq(_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "foo.txt")))
        d_2_fname_ = out0_
        d_3_f_: FileStream = None
        d_4_ok_: bool = False
        out1_: bool
        out2_: FileStream
        out1_, out2_ = FileStream.Open(d_2_fname_)
        d_4_ok_ = out1_
        d_3_f_ = out2_
        if not(d_4_ok_):
            _dafny.print((_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "open failed\n"))).VerbatimString(False))
            return
        d_5_data_: _dafny.Array
        out3_: _dafny.Array
        out3_ = default__.ArrayFromSeq(_dafny.SeqWithoutIsStrInference([104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 33, 10]))
        d_5_data_ = out3_
        out4_: bool
        out4_ = (d_3_f_).Write(0, d_5_data_, 0, (d_5_data_).length(0))
        d_4_ok_ = out4_
        _dafny.print((_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "done!\n"))).VerbatimString(False))


class byte:
    def  __init__(self):
        pass

    @staticmethod
    def default():
        return int(0)
    def _Is(source__):
        return True

class int32:
    def  __init__(self):
        pass

    @staticmethod
    def default():
        return int(0)
    def _Is(source__):
        return True

class nat32:
    def  __init__(self):
        pass

    @staticmethod
    def default():
        return int(0)
    def _Is(source__):
        d_6_i_: int = source__
        return ((0) <= (d_6_i_)) and ((d_6_i_) < (2147483648))

class OkState:
    def  __init__(self):
        pass

    def __dafnystr__(self) -> str:
        return "_module.OkState"

class HostEnvironment:
    def  __init__(self):
        pass

    def __dafnystr__(self) -> str:
        return "_module.HostEnvironment"

class FileStream:
    def  __init__(self):
        pass

    def __dafnystr__(self) -> str:
        return "_module.FileStream"
