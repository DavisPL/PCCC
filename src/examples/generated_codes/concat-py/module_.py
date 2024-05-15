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
    def SafeConcatenate(arr1, arr2):
        result: _dafny.Seq = _dafny.Seq({})
        d_0_safeArr1_: _dafny.Seq
        out0_: _dafny.Seq
        out0_ = default__.RemoveDotDotSlashPattern(arr1)
        d_0_safeArr1_ = out0_
        d_1_safeArr2_: _dafny.Seq
        out1_: _dafny.Seq
        out1_ = default__.RemoveDotDotSlashPattern(arr2)
        d_1_safeArr2_ = out1_
        result = (d_0_safeArr1_) + (d_1_safeArr2_)
        return result

    @staticmethod
    def RemoveDotDotSlashPattern(s):
        result: _dafny.Seq = _dafny.Seq({})
        if (len(s)) < (3):
            result = s
            return result
        d_2_i_: int
        d_2_i_ = 0
        while (d_2_i_) < ((len(s)) - (2)):
            if ((((s)[d_2_i_]) == (_dafny.CodePoint('.'))) and (((s)[(d_2_i_) + (1)]) == (_dafny.CodePoint('.')))) and (((s)[(d_2_i_) + (2)]) == (_dafny.CodePoint('/'))):
                if (d_2_i_) == (0):
                    result = _dafny.SeqWithoutIsStrInference((s)[(d_2_i_) + (3)::])
                elif ((s)[(d_2_i_) - (1)]) == (_dafny.CodePoint('/')):
                    result = (_dafny.SeqWithoutIsStrInference((s)[:(d_2_i_) - (1):])) + (_dafny.SeqWithoutIsStrInference((s)[(d_2_i_) + (3)::]))
                elif True:
                    result = (_dafny.SeqWithoutIsStrInference((s)[:(d_2_i_) - (1):])) + (_dafny.SeqWithoutIsStrInference((s)[(d_2_i_) + (3)::]))
                return result
            d_2_i_ = (d_2_i_) + (1)
        result = s
        return result

    @staticmethod
    def Main(noArgsParameter__):
        d_3_arr1_: _dafny.Seq
        d_3_arr1_ = _dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "some/../path/"))
        d_4_arr2_: _dafny.Seq
        d_4_arr2_ = _dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "../../to/somewhere"))
        d_5_concatenated_: _dafny.Seq
        out2_: _dafny.Seq
        out2_ = default__.SafeConcatenate(d_3_arr1_, d_4_arr2_)
        d_5_concatenated_ = out2_
        _dafny.print((_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "Concatenated array after removing '../' pattern: "))).VerbatimString(False))
        _dafny.print((d_5_concatenated_).VerbatimString(False))

