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

# Module: Std_JSON_ZeroCopy_Deserializer_Strings

class default__:
    def  __init__(self):
        pass

    @staticmethod
    def StringBody(cs):
        pr: Std_Wrappers.Result = Std_Wrappers.Result.default(Std_JSON_Utils_Cursors.Cursor.default)()
        d_640_escaped_: bool
        d_640_escaped_ = False
        hi3_ = (cs).end
        for d_641_point_k_ in range((cs).point, hi3_):
            d_642_byte_: int
            d_642_byte_ = ((cs).s)[d_641_point_k_]
            if ((d_642_byte_) == (ord(_dafny.CodePoint('\"')))) and (not(d_640_escaped_)):
                pr = Std_Wrappers.Result_Success(Std_JSON_Utils_Cursors.Cursor___Cursor((cs).s, (cs).beg, d_641_point_k_, (cs).end))
                return pr
            elif (d_642_byte_) == (ord(_dafny.CodePoint('\\'))):
                d_640_escaped_ = not(d_640_escaped_)
            elif True:
                d_640_escaped_ = False
        pr = Std_Wrappers.Result_Failure(Std_JSON_Utils_Cursors.CursorError_EOF())
        return pr
        return pr

    @staticmethod
    def Quote(cs):
        d_643_valueOrError0_ = (cs).AssertChar(_dafny.CodePoint('\"'))
        if (d_643_valueOrError0_).IsFailure():
            return (d_643_valueOrError0_).PropagateFailure()
        elif True:
            d_644_cs_ = (d_643_valueOrError0_).Extract()
            return Std_Wrappers.Result_Success((d_644_cs_).Split())

    @staticmethod
    def String(cs):
        d_645_valueOrError0_ = default__.Quote(cs)
        if (d_645_valueOrError0_).IsFailure():
            return (d_645_valueOrError0_).PropagateFailure()
        elif True:
            let_tmp_rhs24_ = (d_645_valueOrError0_).Extract()
            d_646_lq_ = let_tmp_rhs24_.t
            d_647_cs_ = let_tmp_rhs24_.cs
            d_648_valueOrError1_ = default__.StringBody(d_647_cs_)
            if (d_648_valueOrError1_).IsFailure():
                return (d_648_valueOrError1_).PropagateFailure()
            elif True:
                d_649_contents_ = (d_648_valueOrError1_).Extract()
                let_tmp_rhs25_ = (d_649_contents_).Split()
                d_650_contents_ = let_tmp_rhs25_.t
                d_651_cs_ = let_tmp_rhs25_.cs
                d_652_valueOrError2_ = default__.Quote(d_651_cs_)
                if (d_652_valueOrError2_).IsFailure():
                    return (d_652_valueOrError2_).PropagateFailure()
                elif True:
                    let_tmp_rhs26_ = (d_652_valueOrError2_).Extract()
                    d_653_rq_ = let_tmp_rhs26_.t
                    d_654_cs_ = let_tmp_rhs26_.cs
                    return Std_Wrappers.Result_Success(Std_JSON_Utils_Cursors.Split_SP(Std_JSON_Grammar.jstring_JString(d_646_lq_, d_650_contents_, d_653_rq_), d_654_cs_))

