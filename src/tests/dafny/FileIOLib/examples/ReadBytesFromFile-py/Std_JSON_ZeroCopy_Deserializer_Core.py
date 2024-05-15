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

# Module: Std_JSON_ZeroCopy_Deserializer_Core

class default__:
    def  __init__(self):
        pass

    @staticmethod
    def Get(cs, err):
        d_622_valueOrError0_ = (cs).Get(err)
        if (d_622_valueOrError0_).IsFailure():
            return (d_622_valueOrError0_).PropagateFailure()
        elif True:
            d_623_cs_ = (d_622_valueOrError0_).Extract()
            return Std_Wrappers.Result_Success((d_623_cs_).Split())

    @staticmethod
    def WS(cs):
        sp: Std_JSON_Utils_Cursors.Split = Std_JSON_Utils_Cursors.Split.default(Std_JSON_Grammar.jblanks.default)()
        d_624_point_k_: int
        d_624_point_k_ = (cs).point
        d_625_end_: int
        d_625_end_ = (cs).end
        while ((d_624_point_k_) < (d_625_end_)) and (Std_JSON_Grammar.default__.Blank_q(((cs).s)[d_624_point_k_])):
            d_624_point_k_ = (d_624_point_k_) + (1)
        sp = (Std_JSON_Utils_Cursors.Cursor___Cursor((cs).s, (cs).beg, d_624_point_k_, (cs).end)).Split()
        return sp
        return sp

    @staticmethod
    def Structural(cs, parser):
        let_tmp_rhs18_ = default__.WS(cs)
        d_626_before_ = let_tmp_rhs18_.t
        d_627_cs_ = let_tmp_rhs18_.cs
        d_628_valueOrError0_ = (parser)(d_627_cs_)
        if (d_628_valueOrError0_).IsFailure():
            return (d_628_valueOrError0_).PropagateFailure()
        elif True:
            let_tmp_rhs19_ = (d_628_valueOrError0_).Extract()
            d_629_val_ = let_tmp_rhs19_.t
            d_630_cs_ = let_tmp_rhs19_.cs
            let_tmp_rhs20_ = default__.WS(d_630_cs_)
            d_631_after_ = let_tmp_rhs20_.t
            d_632_cs_ = let_tmp_rhs20_.cs
            return Std_Wrappers.Result_Success(Std_JSON_Utils_Cursors.Split_SP(Std_JSON_Grammar.Structural_Structural(d_626_before_, d_629_val_, d_631_after_), d_632_cs_))

    @staticmethod
    def TryStructural(cs):
        let_tmp_rhs21_ = default__.WS(cs)
        d_633_before_ = let_tmp_rhs21_.t
        d_634_cs_ = let_tmp_rhs21_.cs
        let_tmp_rhs22_ = ((d_634_cs_).SkipByte()).Split()
        d_635_val_ = let_tmp_rhs22_.t
        d_636_cs_ = let_tmp_rhs22_.cs
        let_tmp_rhs23_ = default__.WS(d_636_cs_)
        d_637_after_ = let_tmp_rhs23_.t
        d_638_cs_ = let_tmp_rhs23_.cs
        return Std_JSON_Utils_Cursors.Split_SP(Std_JSON_Grammar.Structural_Structural(d_633_before_, d_635_val_, d_637_after_), d_638_cs_)

    @_dafny.classproperty
    def SpecView(instance):
        def lambda42_(d_639_v_):
            return Std_JSON_ConcreteSyntax_Spec.default__.View(d_639_v_)

        return lambda42_

class jopt:
    def  __init__(self):
        pass

    @staticmethod
    def default():
        return Std_JSON_Utils_Views_Core.View__.OfBytes(_dafny.SeqWithoutIsStrInference([]))

class ValueParser:
    def  __init__(self):
        pass

    @staticmethod
    def default():
        return Std_JSON_Utils_Parsers.SubParser.default()
