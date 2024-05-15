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

# Module: Std_Unicode_UnicodeStringsWithUnicodeChar

class default__:
    def  __init__(self):
        pass

    @staticmethod
    def CharAsUnicodeScalarValue(c):
        return ord(c)

    @staticmethod
    def CharFromUnicodeScalarValue(sv):
        return _dafny.CodePoint(chr(sv))

    @staticmethod
    def ToUTF8Checked(s):
        d_287_asCodeUnits_ = Std_Collections_Seq.default__.Map(default__.CharAsUnicodeScalarValue, s)
        d_288_asUtf8CodeUnits_ = Std_Unicode_Utf8EncodingForm.default__.EncodeScalarSequence(d_287_asCodeUnits_)
        def lambda13_(d_290_cu_):
            return d_290_cu_

        d_289_asBytes_ = Std_Collections_Seq.default__.Map(lambda13_, d_288_asUtf8CodeUnits_)
        return Std_Wrappers.Option_Some(d_289_asBytes_)

    @staticmethod
    def FromUTF8Checked(bs):
        def lambda14_(d_292_c_):
            return d_292_c_

        d_291_asCodeUnits_ = Std_Collections_Seq.default__.Map(lambda14_, bs)
        d_293_valueOrError0_ = Std_Unicode_Utf8EncodingForm.default__.DecodeCodeUnitSequenceChecked(d_291_asCodeUnits_)
        if (d_293_valueOrError0_).IsFailure():
            return (d_293_valueOrError0_).PropagateFailure()
        elif True:
            d_294_utf32_ = (d_293_valueOrError0_).Extract()
            d_295_asChars_ = Std_Collections_Seq.default__.Map(default__.CharFromUnicodeScalarValue, d_294_utf32_)
            return Std_Wrappers.Option_Some(d_295_asChars_)

    @staticmethod
    def ToUTF16Checked(s):
        d_296_asCodeUnits_ = Std_Collections_Seq.default__.Map(default__.CharAsUnicodeScalarValue, s)
        d_297_asUtf16CodeUnits_ = Std_Unicode_Utf16EncodingForm.default__.EncodeScalarSequence(d_296_asCodeUnits_)
        def lambda15_(d_299_cu_):
            return d_299_cu_

        d_298_asBytes_ = Std_Collections_Seq.default__.Map(lambda15_, d_297_asUtf16CodeUnits_)
        return Std_Wrappers.Option_Some(d_298_asBytes_)

    @staticmethod
    def FromUTF16Checked(bs):
        def lambda16_(d_301_c_):
            return d_301_c_

        d_300_asCodeUnits_ = Std_Collections_Seq.default__.Map(lambda16_, bs)
        d_302_valueOrError0_ = Std_Unicode_Utf16EncodingForm.default__.DecodeCodeUnitSequenceChecked(d_300_asCodeUnits_)
        if (d_302_valueOrError0_).IsFailure():
            return (d_302_valueOrError0_).PropagateFailure()
        elif True:
            d_303_utf32_ = (d_302_valueOrError0_).Extract()
            d_304_asChars_ = Std_Collections_Seq.default__.Map(default__.CharFromUnicodeScalarValue, d_303_utf32_)
            return Std_Wrappers.Option_Some(d_304_asChars_)

    @staticmethod
    def ASCIIToUTF8(s):
        def lambda17_(d_305_c_):
            return ord(d_305_c_)

        return Std_Collections_Seq.default__.Map(lambda17_, s)

    @staticmethod
    def ASCIIToUTF16(s):
        def lambda18_(d_306_c_):
            return ord(d_306_c_)

        return Std_Collections_Seq.default__.Map(lambda18_, s)

