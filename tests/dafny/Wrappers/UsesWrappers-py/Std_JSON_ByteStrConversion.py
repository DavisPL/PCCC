import sys
from typing import Callable, Any, TypeVar, NamedTuple
from math import floor
from itertools import count

import module_
import _dafny
import System_
import Std_Wrappers
import Std_FileIOInternalExterns
import Std_Concurrent
import Std_FileIO
import Std_BoundedInts
import Std_Base64
import Std_Relations
import Std_Math
import Std_Collections_Seq
import Std_Collections_Array
import Std_Collections_Imap
import Std_Functions
import Std_Collections_Iset
import Std_Collections_Map
import Std_Collections_Set
import Std_Collections
import Std_DynamicArray
import Std_Arithmetic_GeneralInternals
import Std_Arithmetic_MulInternalsNonlinear
import Std_Arithmetic_MulInternals
import Std_Arithmetic_Mul
import Std_Arithmetic_ModInternalsNonlinear
import Std_Arithmetic_DivInternalsNonlinear
import Std_Arithmetic_ModInternals
import Std_Arithmetic_DivInternals
import Std_Arithmetic_DivMod
import Std_Arithmetic_Power
import Std_Arithmetic_Logarithm
import Std_Arithmetic_Power2
import Std_Arithmetic
import Std_Strings_HexConversion
import Std_Strings_DecimalConversion
import Std_Strings_CharStrEscaping
import Std_Strings
import Std_Unicode_Base
import Std_Unicode_Utf8EncodingForm
import Std_Unicode_Utf16EncodingForm
import Std_Unicode_UnicodeStringsWithUnicodeChar
import Std_Unicode_Utf8EncodingScheme
import Std_Unicode
import Std_JSON_Values
import Std_JSON_Errors
import Std_JSON_Spec
import Std_JSON_Utils_Views_Core
import Std_JSON_Utils_Views_Writers
import Std_JSON_Utils_Views
import Std_JSON_Utils_Lexers_Core
import Std_JSON_Utils_Lexers_Strings
import Std_JSON_Utils_Lexers
import Std_JSON_Utils_Cursors
import Std_JSON_Utils_Parsers
import Std_JSON_Utils
import Std_JSON_Grammar

# Module: Std_JSON_ByteStrConversion

class default__:
    def  __init__(self):
        pass

    @staticmethod
    def BASE():
        return default__.base

    @staticmethod
    def IsDigitChar(c):
        return (c) in (default__.charToDigit)

    @staticmethod
    def OfDigits(digits):
        d_412___accumulator_ = _dafny.SeqWithoutIsStrInference([])
        while True:
            with _dafny.label():
                if (digits) == (_dafny.SeqWithoutIsStrInference([])):
                    return (_dafny.SeqWithoutIsStrInference([])) + (d_412___accumulator_)
                elif True:
                    d_412___accumulator_ = (_dafny.SeqWithoutIsStrInference([(default__.chars)[(digits)[0]]])) + (d_412___accumulator_)
                    in73_ = _dafny.SeqWithoutIsStrInference((digits)[1::])
                    digits = in73_
                    raise _dafny.TailCall()
                break

    @staticmethod
    def OfNat(n):
        if (n) == (0):
            return _dafny.SeqWithoutIsStrInference([(default__.chars)[0]])
        elif True:
            return default__.OfDigits(default__.FromNat(n))

    @staticmethod
    def IsNumberStr(str, minus):
        def lambda24_(forall_var_3_):
            d_413_c_: int = forall_var_3_
            if True:
                return not ((d_413_c_) in (_dafny.SeqWithoutIsStrInference((str)[1::]))) or (default__.IsDigitChar(d_413_c_))
            elif True:
                return True

        return not ((str) != (_dafny.SeqWithoutIsStrInference([]))) or (((((str)[0]) == (minus)) or (((str)[0]) in (default__.charToDigit))) and (_dafny.quantifier((_dafny.SeqWithoutIsStrInference((str)[1::])).UniqueElements, True, lambda24_)))

    @staticmethod
    def OfInt(n, minus):
        if (n) >= (0):
            return default__.OfNat(n)
        elif True:
            return (_dafny.SeqWithoutIsStrInference([minus])) + (default__.OfNat((0) - (n)))

    @staticmethod
    def ToNat(str):
        if (str) == (_dafny.SeqWithoutIsStrInference([])):
            return 0
        elif True:
            d_414_c_ = (str)[(len(str)) - (1)]
            return ((default__.ToNat(_dafny.SeqWithoutIsStrInference((str)[:(len(str)) - (1):]))) * (default__.base)) + ((default__.charToDigit)[d_414_c_])

    @staticmethod
    def ToInt(str, minus):
        if (_dafny.SeqWithoutIsStrInference([minus])) <= (str):
            return (0) - (default__.ToNat(_dafny.SeqWithoutIsStrInference((str)[1::])))
        elif True:
            return default__.ToNat(str)

    @staticmethod
    def ToNatRight(xs):
        if (len(xs)) == (0):
            return 0
        elif True:
            return ((default__.ToNatRight(Std_Collections_Seq.default__.DropFirst(xs))) * (default__.BASE())) + (Std_Collections_Seq.default__.First(xs))

    @staticmethod
    def ToNatLeft(xs):
        d_415___accumulator_ = 0
        while True:
            with _dafny.label():
                if (len(xs)) == (0):
                    return (0) + (d_415___accumulator_)
                elif True:
                    d_415___accumulator_ = ((Std_Collections_Seq.default__.Last(xs)) * (Std_Arithmetic_Power.default__.Pow(default__.BASE(), (len(xs)) - (1)))) + (d_415___accumulator_)
                    in74_ = Std_Collections_Seq.default__.DropLast(xs)
                    xs = in74_
                    raise _dafny.TailCall()
                break

    @staticmethod
    def FromNat(n):
        d_416___accumulator_ = _dafny.SeqWithoutIsStrInference([])
        while True:
            with _dafny.label():
                if (n) == (0):
                    return (d_416___accumulator_) + (_dafny.SeqWithoutIsStrInference([]))
                elif True:
                    d_416___accumulator_ = (d_416___accumulator_) + (_dafny.SeqWithoutIsStrInference([_dafny.euclidian_modulus(n, default__.BASE())]))
                    in75_ = _dafny.euclidian_division(n, default__.BASE())
                    n = in75_
                    raise _dafny.TailCall()
                break

    @staticmethod
    def SeqExtend(xs, n):
        while True:
            with _dafny.label():
                if (len(xs)) >= (n):
                    return xs
                elif True:
                    in76_ = (xs) + (_dafny.SeqWithoutIsStrInference([0]))
                    in77_ = n
                    xs = in76_
                    n = in77_
                    raise _dafny.TailCall()
                break

    @staticmethod
    def SeqExtendMultiple(xs, n):
        d_417_newLen_ = ((len(xs)) + (n)) - (_dafny.euclidian_modulus(len(xs), n))
        return default__.SeqExtend(xs, d_417_newLen_)

    @staticmethod
    def FromNatWithLen(n, len):
        return default__.SeqExtend(default__.FromNat(n), len)

    @staticmethod
    def SeqZero(len):
        d_418_xs_ = default__.FromNatWithLen(0, len)
        return d_418_xs_

    @staticmethod
    def SeqAdd(xs, ys):
        if (len(xs)) == (0):
            return (_dafny.SeqWithoutIsStrInference([]), 0)
        elif True:
            let_tmp_rhs9_ = default__.SeqAdd(Std_Collections_Seq.default__.DropLast(xs), Std_Collections_Seq.default__.DropLast(ys))
            d_419_zs_k_ = let_tmp_rhs9_[0]
            d_420_cin_ = let_tmp_rhs9_[1]
            d_421_sum_ = ((Std_Collections_Seq.default__.Last(xs)) + (Std_Collections_Seq.default__.Last(ys))) + (d_420_cin_)
            let_tmp_rhs10_ = ((d_421_sum_, 0) if (d_421_sum_) < (default__.BASE()) else ((d_421_sum_) - (default__.BASE()), 1))
            d_422_sum__out_ = let_tmp_rhs10_[0]
            d_423_cout_ = let_tmp_rhs10_[1]
            return ((d_419_zs_k_) + (_dafny.SeqWithoutIsStrInference([d_422_sum__out_])), d_423_cout_)

    @staticmethod
    def SeqSub(xs, ys):
        if (len(xs)) == (0):
            return (_dafny.SeqWithoutIsStrInference([]), 0)
        elif True:
            let_tmp_rhs11_ = default__.SeqSub(Std_Collections_Seq.default__.DropLast(xs), Std_Collections_Seq.default__.DropLast(ys))
            d_424_zs_ = let_tmp_rhs11_[0]
            d_425_cin_ = let_tmp_rhs11_[1]
            let_tmp_rhs12_ = ((((Std_Collections_Seq.default__.Last(xs)) - (Std_Collections_Seq.default__.Last(ys))) - (d_425_cin_), 0) if (Std_Collections_Seq.default__.Last(xs)) >= ((Std_Collections_Seq.default__.Last(ys)) + (d_425_cin_)) else ((((default__.BASE()) + (Std_Collections_Seq.default__.Last(xs))) - (Std_Collections_Seq.default__.Last(ys))) - (d_425_cin_), 1))
            d_426_diff__out_ = let_tmp_rhs12_[0]
            d_427_cout_ = let_tmp_rhs12_[1]
            return ((d_424_zs_) + (_dafny.SeqWithoutIsStrInference([d_426_diff__out_])), d_427_cout_)

    @_dafny.classproperty
    def chars(instance):
        return _dafny.SeqWithoutIsStrInference([ord(_dafny.CodePoint('0')), ord(_dafny.CodePoint('1')), ord(_dafny.CodePoint('2')), ord(_dafny.CodePoint('3')), ord(_dafny.CodePoint('4')), ord(_dafny.CodePoint('5')), ord(_dafny.CodePoint('6')), ord(_dafny.CodePoint('7')), ord(_dafny.CodePoint('8')), ord(_dafny.CodePoint('9'))])
    @_dafny.classproperty
    def base(instance):
        return len(default__.chars)
    @_dafny.classproperty
    def charToDigit(instance):
        return _dafny.Map({ord(_dafny.CodePoint('0')): 0, ord(_dafny.CodePoint('1')): 1, ord(_dafny.CodePoint('2')): 2, ord(_dafny.CodePoint('3')): 3, ord(_dafny.CodePoint('4')): 4, ord(_dafny.CodePoint('5')): 5, ord(_dafny.CodePoint('6')): 6, ord(_dafny.CodePoint('7')): 7, ord(_dafny.CodePoint('8')): 8, ord(_dafny.CodePoint('9')): 9})

class CharSeq:
    def  __init__(self):
        pass

    @staticmethod
    def default():
        return _dafny.Seq({})
    def _Is(source__):
        d_428_chars_: _dafny.Seq = source__
        return (len(d_428_chars_)) > (1)

class digit:
    def  __init__(self):
        pass

    @staticmethod
    def default():
        return int(0)
    def _Is(source__):
        d_429_i_: int = source__
        if System_.nat._Is(d_429_i_):
            return ((0) <= (d_429_i_)) and ((d_429_i_) < (default__.BASE()))
        return False
