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
import Std_JSON_Serializer
import Std_JSON_Deserializer_Uint16StrConversion
import Std_JSON_Deserializer
import Std_JSON_ConcreteSyntax_Spec
import Std_JSON_ConcreteSyntax_SpecProperties
import Std_JSON_ConcreteSyntax
import Std_JSON_ZeroCopy_Serializer
import Std_JSON_ZeroCopy_Deserializer_Core
import Std_JSON_ZeroCopy_Deserializer_Strings
import Std_JSON_ZeroCopy_Deserializer_Numbers

# Module: Std_JSON_ZeroCopy_Deserializer_ObjectParams

class default__:
    def  __init__(self):
        pass

    @staticmethod
    def Colon(cs):
        d_682_valueOrError0_ = (cs).AssertChar(_dafny.CodePoint(':'))
        if (d_682_valueOrError0_).IsFailure():
            return (d_682_valueOrError0_).PropagateFailure()
        elif True:
            d_683_cs_ = (d_682_valueOrError0_).Extract()
            return Std_Wrappers.Result_Success((d_683_cs_).Split())

    @staticmethod
    def KeyValueFromParts(k, colon, v):
        d_684_sp_ = Std_JSON_Utils_Cursors.Split_SP(Std_JSON_Grammar.jKeyValue_KeyValue((k).t, (colon).t, (v).t), (v).cs)
        return d_684_sp_

    @staticmethod
    def ElementSpec(t):
        return Std_JSON_ConcreteSyntax_Spec.default__.KeyValue(t)

    @staticmethod
    def Element(cs, json):
        d_685_valueOrError0_ = Std_JSON_ZeroCopy_Deserializer_Strings.default__.String(cs)
        if (d_685_valueOrError0_).IsFailure():
            return (d_685_valueOrError0_).PropagateFailure()
        elif True:
            d_686_k_ = (d_685_valueOrError0_).Extract()
            d_687_p_ = default__.Colon
            d_688_valueOrError1_ = Std_JSON_ZeroCopy_Deserializer_Core.default__.Structural((d_686_k_).cs, d_687_p_)
            if (d_688_valueOrError1_).IsFailure():
                return (d_688_valueOrError1_).PropagateFailure()
            elif True:
                d_689_colon_ = (d_688_valueOrError1_).Extract()
                d_690_valueOrError2_ = (json)((d_689_colon_).cs)
                if (d_690_valueOrError2_).IsFailure():
                    return (d_690_valueOrError2_).PropagateFailure()
                elif True:
                    d_691_v_ = (d_690_valueOrError2_).Extract()
                    d_692_kv_ = default__.KeyValueFromParts(d_686_k_, d_689_colon_, d_691_v_)
                    return Std_Wrappers.Result_Success(d_692_kv_)

    @_dafny.classproperty
    def OPEN(instance):
        return ord(_dafny.CodePoint('{'))
    @_dafny.classproperty
    def CLOSE(instance):
        return ord(_dafny.CodePoint('}'))
