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
    def DigitTochar(n):
        return (_dafny.CodePoint('0')) + (_dafny.CodePoint(chr(n)))

    @staticmethod
    def NumberToString(n):
        d_0___accumulator_ = _dafny.SeqWithoutIsStrInference([])
        while True:
            with _dafny.label():
                if (n) < (10):
                    return (_dafny.SeqWithoutIsStrInference([default__.DigitTochar(n)])) + (d_0___accumulator_)
                elif True:
                    d_0___accumulator_ = (_dafny.SeqWithoutIsStrInference([default__.DigitTochar(_dafny.euclidian_modulus(n, 10))])) + (d_0___accumulator_)
                    in0_ = _dafny.euclidian_division(n, 10)
                    n = in0_
                    raise _dafny.TailCall()
                break

    @staticmethod
    def ComputeDigitTochar(n):
        result: str = _dafny.CodePoint('D')
        result = (_dafny.CodePoint('0')) + (_dafny.CodePoint(chr(n)))
        return result
        return result

    @staticmethod
    def ComputeNumberToString(n):
        r: _dafny.Seq = _dafny.Seq({})
        if (n) < (10):
            d_1_digitToChar_: str
            out0_: str
            out0_ = default__.ComputeDigitTochar(n)
            d_1_digitToChar_ = out0_
            r = _dafny.SeqWithoutIsStrInference([d_1_digitToChar_])
        elif True:
            d_2_numToChar_: _dafny.Seq
            out1_: _dafny.Seq
            out1_ = default__.ComputeNumberToString(_dafny.euclidian_division(n, 10))
            d_2_numToChar_ = out1_
            d_3_digitToChar_: str
            out2_: str
            out2_ = default__.ComputeDigitTochar(_dafny.euclidian_modulus(n, 10))
            d_3_digitToChar_ = out2_
            r = (d_2_numToChar_) + (_dafny.SeqWithoutIsStrInference([d_3_digitToChar_]))
        return r

    @staticmethod
    def CharToByte(c):
        if (ord(c)) < (256):
            return ord(c)
        elif True:
            return 0

    @staticmethod
    def StringToBytesRec(s, i):
        d_4___accumulator_ = _dafny.SeqWithoutIsStrInference([])
        while True:
            with _dafny.label():
                if (i) == (len(s)):
                    return (d_4___accumulator_) + (_dafny.SeqWithoutIsStrInference([]))
                elif True:
                    d_4___accumulator_ = (d_4___accumulator_) + (_dafny.SeqWithoutIsStrInference([default__.CharToByte((s)[i])]))
                    in1_ = s
                    in2_ = (i) + (1)
                    s = in1_
                    i = in2_
                    raise _dafny.TailCall()
                break

    @staticmethod
    def StringToBytes(s):
        return default__.StringToBytesRec(s, 0)

    @staticmethod
    def ComputeStringToBytes(s):
        bytesSeq: _dafny.Seq = _dafny.Seq({})
        bytesSeq = _dafny.SeqWithoutIsStrInference([])
        d_5_i_: int
        d_5_i_ = 0
        while (d_5_i_) < (len(s)):
            bytesSeq = (bytesSeq) + (_dafny.SeqWithoutIsStrInference([default__.CharToByte((s)[d_5_i_])]))
            _dafny.print(_dafny.string_of(bytesSeq))
            d_5_i_ = (d_5_i_) + (1)
        return bytesSeq

    @staticmethod
    def ArrayFromSeq(s):
        a: _dafny.Array = _dafny.Array(None, 0)
        def lambda0_(d_6_s_):
            def lambda1_(d_7_i_):
                return (d_6_s_)[d_7_i_]

            return lambda1_

        init0_ = lambda0_(s)
        nw0_ = _dafny.Array(None, len(s))
        for i0_0_ in range(nw0_.length(0)):
            nw0_[i0_0_] = init0_(i0_0_)
        a = nw0_
        return a

    @staticmethod
    def Fib(n):
        if (n) == (0):
            return 0
        elif (n) == (1):
            return 1
        elif True:
            return (default__.Fib((n) - (1))) + (default__.Fib((n) - (2)))

    @staticmethod
    def ComputeFibonacci(n):
        result: int = int(0)
        d_8_prev_: int
        d_8_prev_ = 0
        d_9_curr_: int
        d_9_curr_ = 1
        if (n) == (0):
            result = 0
            return result
        d_10_i_: int
        d_10_i_ = 1
        while (d_10_i_) < (n):
            d_11_next_: int
            d_11_next_ = (d_8_prev_) + (d_9_curr_)
            d_8_prev_ = d_9_curr_
            d_9_curr_ = d_11_next_
            d_10_i_ = (d_10_i_) + (1)
        result = d_9_curr_
        return result

    @staticmethod
    def FibonacciToByteSequence(n):
        byteSeq: _dafny.Seq = _dafny.Seq({})
        d_12_fibo_: int
        out3_: int
        out3_ = default__.ComputeFibonacci(n)
        d_12_fibo_ = out3_
        d_13_fibString_: _dafny.Seq
        out4_: _dafny.Seq
        out4_ = default__.ComputeNumberToString(d_12_fibo_)
        d_13_fibString_ = out4_
        out5_: _dafny.Seq
        out5_ = default__.ComputeStringToBytes(d_13_fibString_)
        byteSeq = out5_
        _dafny.print((_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "fibonacci number: "))).VerbatimString(False))
        _dafny.print(_dafny.string_of(d_12_fibo_))
        _dafny.print((_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "\n"))).VerbatimString(False))
        _dafny.print((_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "String generated from fibonacci number: "))).VerbatimString(False))
        _dafny.print((d_13_fibString_).VerbatimString(False))
        _dafny.print((_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "\n"))).VerbatimString(False))
        return byteSeq

    @staticmethod
    def IsFileInSet(filename, files):
        found: bool = False
        found = (filename) in (files)
        return found

    @staticmethod
    def Main(noArgsParameter__):
        d_14_n_: int
        d_14_n_ = 100
        d_15_arrayOfBytesFib_: _dafny.Seq
        out6_: _dafny.Seq
        out6_ = default__.FibonacciToByteSequence(d_14_n_)
        d_15_arrayOfBytesFib_ = out6_
        d_16_fname_: _dafny.Array
        out7_: _dafny.Array
        out7_ = default__.ArrayFromSeq(_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "foo.txt")))
        d_16_fname_ = out7_
        d_17_f_: FileStream = None
        d_18_ok_: bool = False
        d_19_data_: _dafny.Array
        out8_: _dafny.Array
        out8_ = default__.ArrayFromSeq(d_15_arrayOfBytesFib_)
        d_19_data_ = out8_
        d_20_i_: int
        d_20_i_ = 0
        while (d_20_i_) < ((d_19_data_).length(0)):
            _dafny.print(_dafny.string_of((d_19_data_)[d_20_i_]))
            _dafny.print((_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "\n"))).VerbatimString(False))
            d_20_i_ = (d_20_i_) + (1)
        _dafny.print((_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "\n done! \n"))).VerbatimString(False))


class byte:
    def  __init__(self):
        pass

    @staticmethod
    def default():
        return int(0)

class int32:
    def  __init__(self):
        pass

    @staticmethod
    def default():
        return int(0)

class nat32:
    def  __init__(self):
        pass

    @staticmethod
    def default():
        return int(0)

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
