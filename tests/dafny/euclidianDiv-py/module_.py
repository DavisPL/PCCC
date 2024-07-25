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
    def EuclidianDiv(a, b):
        q: int = int(0)
        r: int = int(0)
        if (a) < (b):
            q = 0
            r = a
        elif True:
            d_0_q_k_: int
            d_1_r_k_: int
            out0_: int
            out1_: int
            out0_, out1_ = default__.EuclidianDiv((a) - (b), b)
            d_0_q_k_ = out0_
            d_1_r_k_ = out1_
            q = (d_0_q_k_) + (1)
            r = d_1_r_k_
        return q, r

    @staticmethod
    def Main(noArgsParameter__):
        d_2_a_: int
        d_3_b_: int
        rhs0_ = 47
        rhs1_ = 13
        d_2_a_ = rhs0_
        d_3_b_ = rhs1_
        d_4_q_: int
        d_5_r_: int
        out2_: int
        out3_: int
        out2_, out3_ = default__.EuclidianDiv(d_2_a_, d_3_b_)
        d_4_q_ = out2_
        d_5_r_ = out3_
        _dafny.print(_dafny.string_of(d_2_a_))
        _dafny.print((_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, " = "))).VerbatimString(False))
        _dafny.print(_dafny.string_of(d_4_q_))
        _dafny.print((_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "*"))).VerbatimString(False))
        _dafny.print(_dafny.string_of(d_3_b_))
        _dafny.print((_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, " + "))).VerbatimString(False))
        _dafny.print(_dafny.string_of(d_5_r_))

