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

# Module: Std_JSON_Spec

class default__:
    def  __init__(self):
        pass

    @staticmethod
    def EscapeUnicode(c):
        d_327_sStr_ = Std_Strings_HexConversion.default__.OfNat(c)
        d_328_s_ = Std_Unicode_UnicodeStringsWithUnicodeChar.default__.ASCIIToUTF16(d_327_sStr_)
        return (d_328_s_) + (_dafny.SeqWithoutIsStrInference([ord(_dafny.CodePoint(' ')) for d_329___v8_ in range((4) - (len(d_328_s_)))]))

    @staticmethod
    def Escape(str, start):
        d_330___accumulator_ = _dafny.SeqWithoutIsStrInference([])
        while True:
            with _dafny.label():
                pat_let_tv0_ = str
                pat_let_tv1_ = start
                def iife7_(_pat_let1_0):
                    def iife8_(d_331_c_):
                        return ((Std_Unicode_UnicodeStringsWithUnicodeChar.default__.ASCIIToUTF16(_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "\\u")))) + (default__.EscapeUnicode(d_331_c_)) if (d_331_c_) < (31) else _dafny.SeqWithoutIsStrInference([(pat_let_tv0_)[pat_let_tv1_]]))
                    return iife8_(_pat_let1_0)
                if (start) >= (len(str)):
                    return (d_330___accumulator_) + (_dafny.SeqWithoutIsStrInference([]))
                elif True:
                    d_330___accumulator_ = (d_330___accumulator_) + ((Std_Unicode_UnicodeStringsWithUnicodeChar.default__.ASCIIToUTF16(_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "\\\""))) if ((str)[start]) == (34) else (Std_Unicode_UnicodeStringsWithUnicodeChar.default__.ASCIIToUTF16(_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "\\\\"))) if ((str)[start]) == (92) else (Std_Unicode_UnicodeStringsWithUnicodeChar.default__.ASCIIToUTF16(_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "\\b"))) if ((str)[start]) == (8) else (Std_Unicode_UnicodeStringsWithUnicodeChar.default__.ASCIIToUTF16(_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "\\f"))) if ((str)[start]) == (12) else (Std_Unicode_UnicodeStringsWithUnicodeChar.default__.ASCIIToUTF16(_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "\\n"))) if ((str)[start]) == (10) else (Std_Unicode_UnicodeStringsWithUnicodeChar.default__.ASCIIToUTF16(_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "\\r"))) if ((str)[start]) == (13) else (Std_Unicode_UnicodeStringsWithUnicodeChar.default__.ASCIIToUTF16(_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "\\t"))) if ((str)[start]) == (9) else iife7_((str)[start])))))))))
                    in62_ = str
                    in63_ = (start) + (1)
                    str = in62_
                    start = in63_
                    raise _dafny.TailCall()
                break

    @staticmethod
    def EscapeToUTF8(str, start):
        d_332_valueOrError0_ = (Std_Unicode_UnicodeStringsWithUnicodeChar.default__.ToUTF16Checked(str)).ToResult(Std_JSON_Errors.SerializationError_InvalidUnicode())
        if (d_332_valueOrError0_).IsFailure():
            return (d_332_valueOrError0_).PropagateFailure()
        elif True:
            d_333_utf16_ = (d_332_valueOrError0_).Extract()
            d_334_escaped_ = default__.Escape(d_333_utf16_, 0)
            d_335_valueOrError1_ = (Std_Unicode_UnicodeStringsWithUnicodeChar.default__.FromUTF16Checked(d_334_escaped_)).ToResult(Std_JSON_Errors.SerializationError_InvalidUnicode())
            if (d_335_valueOrError1_).IsFailure():
                return (d_335_valueOrError1_).PropagateFailure()
            elif True:
                d_336_utf32_ = (d_335_valueOrError1_).Extract()
                return (Std_Unicode_UnicodeStringsWithUnicodeChar.default__.ToUTF8Checked(d_336_utf32_)).ToResult(Std_JSON_Errors.SerializationError_InvalidUnicode())

    @staticmethod
    def String(str):
        d_337_valueOrError0_ = default__.EscapeToUTF8(str, 0)
        if (d_337_valueOrError0_).IsFailure():
            return (d_337_valueOrError0_).PropagateFailure()
        elif True:
            d_338_inBytes_ = (d_337_valueOrError0_).Extract()
            return Std_Wrappers.Result_Success(((Std_Unicode_UnicodeStringsWithUnicodeChar.default__.ASCIIToUTF8(_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "\"")))) + (d_338_inBytes_)) + (Std_Unicode_UnicodeStringsWithUnicodeChar.default__.ASCIIToUTF8(_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "\"")))))

    @staticmethod
    def IntToBytes(n):
        d_339_s_ = Std_Strings.default__.OfInt(n)
        return Std_Unicode_UnicodeStringsWithUnicodeChar.default__.ASCIIToUTF8(d_339_s_)

    @staticmethod
    def Number(dec):
        return Std_Wrappers.Result_Success((default__.IntToBytes((dec).n)) + ((_dafny.SeqWithoutIsStrInference([]) if ((dec).e10) == (0) else (Std_Unicode_UnicodeStringsWithUnicodeChar.default__.ASCIIToUTF8(_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "e")))) + (default__.IntToBytes((dec).e10)))))

    @staticmethod
    def KeyValue(kv):
        d_340_valueOrError0_ = default__.String((kv)[0])
        if (d_340_valueOrError0_).IsFailure():
            return (d_340_valueOrError0_).PropagateFailure()
        elif True:
            d_341_key_ = (d_340_valueOrError0_).Extract()
            d_342_valueOrError1_ = default__.JSON((kv)[1])
            if (d_342_valueOrError1_).IsFailure():
                return (d_342_valueOrError1_).PropagateFailure()
            elif True:
                d_343_value_ = (d_342_valueOrError1_).Extract()
                return Std_Wrappers.Result_Success(((d_341_key_) + (Std_Unicode_UnicodeStringsWithUnicodeChar.default__.ASCIIToUTF8(_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, ":"))))) + (d_343_value_))

    @staticmethod
    def Join(sep, items):
        if (len(items)) == (0):
            return Std_Wrappers.Result_Success(_dafny.SeqWithoutIsStrInference([]))
        elif True:
            d_344_valueOrError0_ = (items)[0]
            if (d_344_valueOrError0_).IsFailure():
                return (d_344_valueOrError0_).PropagateFailure()
            elif True:
                d_345_first_ = (d_344_valueOrError0_).Extract()
                if (len(items)) == (1):
                    return Std_Wrappers.Result_Success(d_345_first_)
                elif True:
                    d_346_valueOrError1_ = default__.Join(sep, _dafny.SeqWithoutIsStrInference((items)[1::]))
                    if (d_346_valueOrError1_).IsFailure():
                        return (d_346_valueOrError1_).PropagateFailure()
                    elif True:
                        d_347_rest_ = (d_346_valueOrError1_).Extract()
                        return Std_Wrappers.Result_Success(((d_345_first_) + (sep)) + (d_347_rest_))

    @staticmethod
    def Object(obj):
        d_348_valueOrError0_ = default__.Join(Std_Unicode_UnicodeStringsWithUnicodeChar.default__.ASCIIToUTF8(_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, ","))), _dafny.SeqWithoutIsStrInference([default__.KeyValue((obj)[d_349_i_]) for d_349_i_ in range(len(obj))]))
        if (d_348_valueOrError0_).IsFailure():
            return (d_348_valueOrError0_).PropagateFailure()
        elif True:
            d_350_middle_ = (d_348_valueOrError0_).Extract()
            return Std_Wrappers.Result_Success(((Std_Unicode_UnicodeStringsWithUnicodeChar.default__.ASCIIToUTF8(_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "{")))) + (d_350_middle_)) + (Std_Unicode_UnicodeStringsWithUnicodeChar.default__.ASCIIToUTF8(_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "}")))))

    @staticmethod
    def Array(arr):
        d_351_valueOrError0_ = default__.Join(Std_Unicode_UnicodeStringsWithUnicodeChar.default__.ASCIIToUTF8(_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, ","))), _dafny.SeqWithoutIsStrInference([default__.JSON((arr)[d_352_i_]) for d_352_i_ in range(len(arr))]))
        if (d_351_valueOrError0_).IsFailure():
            return (d_351_valueOrError0_).PropagateFailure()
        elif True:
            d_353_middle_ = (d_351_valueOrError0_).Extract()
            return Std_Wrappers.Result_Success(((Std_Unicode_UnicodeStringsWithUnicodeChar.default__.ASCIIToUTF8(_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "[")))) + (d_353_middle_)) + (Std_Unicode_UnicodeStringsWithUnicodeChar.default__.ASCIIToUTF8(_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "]")))))

    @staticmethod
    def JSON(js):
        source12_ = js
        if source12_.is_Null:
            return Std_Wrappers.Result_Success(Std_Unicode_UnicodeStringsWithUnicodeChar.default__.ASCIIToUTF8(_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "null"))))
        elif source12_.is_Bool:
            d_354___mcc_h0_ = source12_.b
            d_355_b_ = d_354___mcc_h0_
            return Std_Wrappers.Result_Success((Std_Unicode_UnicodeStringsWithUnicodeChar.default__.ASCIIToUTF8(_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "true"))) if d_355_b_ else Std_Unicode_UnicodeStringsWithUnicodeChar.default__.ASCIIToUTF8(_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "false")))))
        elif source12_.is_String:
            d_356___mcc_h1_ = source12_.str
            d_357_str_ = d_356___mcc_h1_
            return default__.String(d_357_str_)
        elif source12_.is_Number:
            d_358___mcc_h2_ = source12_.num
            d_359_dec_ = d_358___mcc_h2_
            return default__.Number(d_359_dec_)
        elif source12_.is_Object:
            d_360___mcc_h3_ = source12_.obj
            d_361_obj_ = d_360___mcc_h3_
            return default__.Object(d_361_obj_)
        elif True:
            d_362___mcc_h4_ = source12_.arr
            d_363_arr_ = d_362___mcc_h4_
            return default__.Array(d_363_arr_)

