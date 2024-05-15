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
import Std_JSON_ByteStrConversion

# Module: Std_JSON_Serializer

class default__:
    def  __init__(self):
        pass

    @staticmethod
    def Bool(b):
        return Std_JSON_Utils_Views_Core.View__.OfBytes((Std_JSON_Grammar.default__.TRUE if b else Std_JSON_Grammar.default__.FALSE))

    @staticmethod
    def CheckLength(s, err):
        return Std_Wrappers.Outcome.Need((len(s)) < (Std_BoundedInts.default__.TWO__TO__THE__32), err)

    @staticmethod
    def String(str):
        d_430_valueOrError0_ = Std_JSON_Spec.default__.EscapeToUTF8(str, 0)
        if (d_430_valueOrError0_).IsFailure():
            return (d_430_valueOrError0_).PropagateFailure()
        elif True:
            d_431_bs_ = (d_430_valueOrError0_).Extract()
            d_432_o_ = default__.CheckLength(d_431_bs_, Std_JSON_Errors.SerializationError_StringTooLong(str))
            if (d_432_o_).is_Pass:
                return Std_Wrappers.Result_Success(Std_JSON_Grammar.jstring_JString(Std_JSON_Grammar.default__.DOUBLEQUOTE, Std_JSON_Utils_Views_Core.View__.OfBytes(d_431_bs_), Std_JSON_Grammar.default__.DOUBLEQUOTE))
            elif True:
                return Std_Wrappers.Result_Failure((d_432_o_).error)

    @staticmethod
    def Sign(n):
        return Std_JSON_Utils_Views_Core.View__.OfBytes((_dafny.SeqWithoutIsStrInference([ord(_dafny.CodePoint('-'))]) if (n) < (0) else _dafny.SeqWithoutIsStrInference([])))

    @staticmethod
    def Int_k(n):
        return Std_JSON_ByteStrConversion.default__.OfInt(n, default__.MINUS)

    @staticmethod
    def Int(n):
        d_433_bs_ = default__.Int_k(n)
        d_434_o_ = default__.CheckLength(d_433_bs_, Std_JSON_Errors.SerializationError_IntTooLarge(n))
        if (d_434_o_).is_Pass:
            return Std_Wrappers.Result_Success(Std_JSON_Utils_Views_Core.View__.OfBytes(d_433_bs_))
        elif True:
            return Std_Wrappers.Result_Failure((d_434_o_).error)

    @staticmethod
    def Number(dec):
        pat_let_tv2_ = dec
        pat_let_tv3_ = dec
        d_435_minus_ = default__.Sign((dec).n)
        d_436_valueOrError0_ = default__.Int(Std_Math.default__.Abs((dec).n))
        if (d_436_valueOrError0_).IsFailure():
            return (d_436_valueOrError0_).PropagateFailure()
        elif True:
            d_437_num_ = (d_436_valueOrError0_).Extract()
            d_438_frac_ = Std_JSON_Grammar.Maybe_Empty()
            def iife9_(_pat_let2_0):
                def iife10_(d_440_e_):
                    def iife11_(_pat_let3_0):
                        def iife12_(d_441_sign_):
                            def iife13_(_pat_let4_0):
                                def iife14_(d_442_valueOrError2_):
                                    def iife15_(_pat_let5_0):
                                        def iife16_(d_443_num_):
                                            return Std_Wrappers.Result_Success(Std_JSON_Grammar.Maybe_NonEmpty(Std_JSON_Grammar.jexp_JExp(d_440_e_, d_441_sign_, d_443_num_)))
                                        return iife16_(_pat_let5_0)
                                    return ((d_442_valueOrError2_).PropagateFailure() if (d_442_valueOrError2_).IsFailure() else iife15_((d_442_valueOrError2_).Extract()))
                                return iife14_(_pat_let4_0)
                            return iife13_(default__.Int(Std_Math.default__.Abs((pat_let_tv3_).e10)))
                        return iife12_(_pat_let3_0)
                    return iife11_(default__.Sign((pat_let_tv2_).e10))
                return iife10_(_pat_let2_0)
            d_439_valueOrError1_ = (Std_Wrappers.Result_Success(Std_JSON_Grammar.Maybe_Empty()) if ((dec).e10) == (0) else iife9_(Std_JSON_Utils_Views_Core.View__.OfBytes(_dafny.SeqWithoutIsStrInference([ord(_dafny.CodePoint('e'))]))))
            if (d_439_valueOrError1_).IsFailure():
                return (d_439_valueOrError1_).PropagateFailure()
            elif True:
                d_444_exp_ = (d_439_valueOrError1_).Extract()
                return Std_Wrappers.Result_Success(Std_JSON_Grammar.jnumber_JNumber(d_435_minus_, d_437_num_, Std_JSON_Grammar.Maybe_Empty(), d_444_exp_))

    @staticmethod
    def MkStructural(v):
        return Std_JSON_Grammar.Structural_Structural(Std_JSON_Grammar.default__.EMPTY, v, Std_JSON_Grammar.default__.EMPTY)

    @staticmethod
    def KeyValue(kv):
        d_445_valueOrError0_ = default__.String((kv)[0])
        if (d_445_valueOrError0_).IsFailure():
            return (d_445_valueOrError0_).PropagateFailure()
        elif True:
            d_446_k_ = (d_445_valueOrError0_).Extract()
            d_447_valueOrError1_ = default__.Value((kv)[1])
            if (d_447_valueOrError1_).IsFailure():
                return (d_447_valueOrError1_).PropagateFailure()
            elif True:
                d_448_v_ = (d_447_valueOrError1_).Extract()
                return Std_Wrappers.Result_Success(Std_JSON_Grammar.jKeyValue_KeyValue(d_446_k_, default__.COLON, d_448_v_))

    @staticmethod
    def MkSuffixedSequence(ds, suffix, start):
        d_449___accumulator_ = _dafny.SeqWithoutIsStrInference([])
        while True:
            with _dafny.label():
                if (start) >= (len(ds)):
                    return (d_449___accumulator_) + (_dafny.SeqWithoutIsStrInference([]))
                elif (start) == ((len(ds)) - (1)):
                    return (d_449___accumulator_) + (_dafny.SeqWithoutIsStrInference([Std_JSON_Grammar.Suffixed_Suffixed((ds)[start], Std_JSON_Grammar.Maybe_Empty())]))
                elif True:
                    d_449___accumulator_ = (d_449___accumulator_) + (_dafny.SeqWithoutIsStrInference([Std_JSON_Grammar.Suffixed_Suffixed((ds)[start], Std_JSON_Grammar.Maybe_NonEmpty(suffix))]))
                    in78_ = ds
                    in79_ = suffix
                    in80_ = (start) + (1)
                    ds = in78_
                    suffix = in79_
                    start = in80_
                    raise _dafny.TailCall()
                break

    @staticmethod
    def Object(obj):
        def lambda25_(d_451_obj_):
            def lambda26_(d_452_v_):
                return default__.KeyValue(d_452_v_)

            return lambda26_

        d_450_valueOrError0_ = Std_Collections_Seq.default__.MapWithResult(lambda25_(obj), obj)
        if (d_450_valueOrError0_).IsFailure():
            return (d_450_valueOrError0_).PropagateFailure()
        elif True:
            d_453_items_ = (d_450_valueOrError0_).Extract()
            return Std_Wrappers.Result_Success(Std_JSON_Grammar.Bracketed_Bracketed(default__.MkStructural(Std_JSON_Grammar.default__.LBRACE), default__.MkSuffixedSequence(d_453_items_, default__.COMMA, 0), default__.MkStructural(Std_JSON_Grammar.default__.RBRACE)))

    @staticmethod
    def Array(arr):
        def lambda27_(d_455_arr_):
            def lambda28_(d_456_v_):
                return default__.Value(d_456_v_)

            return lambda28_

        d_454_valueOrError0_ = Std_Collections_Seq.default__.MapWithResult(lambda27_(arr), arr)
        if (d_454_valueOrError0_).IsFailure():
            return (d_454_valueOrError0_).PropagateFailure()
        elif True:
            d_457_items_ = (d_454_valueOrError0_).Extract()
            return Std_Wrappers.Result_Success(Std_JSON_Grammar.Bracketed_Bracketed(default__.MkStructural(Std_JSON_Grammar.default__.LBRACKET), default__.MkSuffixedSequence(d_457_items_, default__.COMMA, 0), default__.MkStructural(Std_JSON_Grammar.default__.RBRACKET)))

    @staticmethod
    def Value(js):
        source16_ = js
        if source16_.is_Null:
            return Std_Wrappers.Result_Success(Std_JSON_Grammar.Value_Null(Std_JSON_Utils_Views_Core.View__.OfBytes(Std_JSON_Grammar.default__.NULL)))
        elif source16_.is_Bool:
            d_458___mcc_h0_ = source16_.b
            d_459_b_ = d_458___mcc_h0_
            return Std_Wrappers.Result_Success(Std_JSON_Grammar.Value_Bool(default__.Bool(d_459_b_)))
        elif source16_.is_String:
            d_460___mcc_h1_ = source16_.str
            d_461_str_ = d_460___mcc_h1_
            d_462_valueOrError0_ = default__.String(d_461_str_)
            if (d_462_valueOrError0_).IsFailure():
                return (d_462_valueOrError0_).PropagateFailure()
            elif True:
                d_463_s_ = (d_462_valueOrError0_).Extract()
                return Std_Wrappers.Result_Success(Std_JSON_Grammar.Value_String(d_463_s_))
        elif source16_.is_Number:
            d_464___mcc_h2_ = source16_.num
            d_465_dec_ = d_464___mcc_h2_
            d_466_valueOrError1_ = default__.Number(d_465_dec_)
            if (d_466_valueOrError1_).IsFailure():
                return (d_466_valueOrError1_).PropagateFailure()
            elif True:
                d_467_n_ = (d_466_valueOrError1_).Extract()
                return Std_Wrappers.Result_Success(Std_JSON_Grammar.Value_Number(d_467_n_))
        elif source16_.is_Object:
            d_468___mcc_h3_ = source16_.obj
            d_469_obj_ = d_468___mcc_h3_
            d_470_valueOrError2_ = default__.Object(d_469_obj_)
            if (d_470_valueOrError2_).IsFailure():
                return (d_470_valueOrError2_).PropagateFailure()
            elif True:
                d_471_o_ = (d_470_valueOrError2_).Extract()
                return Std_Wrappers.Result_Success(Std_JSON_Grammar.Value_Object(d_471_o_))
        elif True:
            d_472___mcc_h4_ = source16_.arr
            d_473_arr_ = d_472___mcc_h4_
            d_474_valueOrError3_ = default__.Array(d_473_arr_)
            if (d_474_valueOrError3_).IsFailure():
                return (d_474_valueOrError3_).PropagateFailure()
            elif True:
                d_475_a_ = (d_474_valueOrError3_).Extract()
                return Std_Wrappers.Result_Success(Std_JSON_Grammar.Value_Array(d_475_a_))

    @staticmethod
    def JSON(js):
        d_476_valueOrError0_ = default__.Value(js)
        if (d_476_valueOrError0_).IsFailure():
            return (d_476_valueOrError0_).PropagateFailure()
        elif True:
            d_477_val_ = (d_476_valueOrError0_).Extract()
            return Std_Wrappers.Result_Success(default__.MkStructural(d_477_val_))

    @_dafny.classproperty
    def DIGITS(instance):
        return Std_JSON_ByteStrConversion.default__.chars
    @_dafny.classproperty
    def MINUS(instance):
        return ord(_dafny.CodePoint('-'))
    @_dafny.classproperty
    def COLON(instance):
        return default__.MkStructural(Std_JSON_Grammar.default__.COLON)
    @_dafny.classproperty
    def COMMA(instance):
        return default__.MkStructural(Std_JSON_Grammar.default__.COMMA)

class bytes32:
    def  __init__(self):
        pass

    @staticmethod
    def default():
        return _dafny.Seq({})
    def _Is(source__):
        d_478_bs_: _dafny.Seq = source__
        return (len(d_478_bs_)) < (Std_BoundedInts.default__.TWO__TO__THE__32)

class string32:
    def  __init__(self):
        pass

    @staticmethod
    def default():
        return _dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, ""))
    def _Is(source__):
        d_479_s_: _dafny.Seq = source__
        return (len(d_479_s_)) < (Std_BoundedInts.default__.TWO__TO__THE__32)
