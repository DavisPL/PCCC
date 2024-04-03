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
import Std_JSON_ZeroCopy_Deserializer_ObjectParams

# Module: Std_JSON_ZeroCopy_Deserializer_Objects

class default__:
    def  __init__(self):
        pass

    @staticmethod
    def Object(cs, json):
        d_693_valueOrError0_ = default__.Bracketed(cs, json)
        if (d_693_valueOrError0_).IsFailure():
            return (d_693_valueOrError0_).PropagateFailure()
        elif True:
            d_694_sp_ = (d_693_valueOrError0_).Extract()
            return Std_Wrappers.Result_Success(d_694_sp_)

    @staticmethod
    def Open(cs):
        d_695_valueOrError0_ = (cs).AssertByte(Std_JSON_ZeroCopy_Deserializer_ObjectParams.default__.OPEN)
        if (d_695_valueOrError0_).IsFailure():
            return (d_695_valueOrError0_).PropagateFailure()
        elif True:
            d_696_cs_ = (d_695_valueOrError0_).Extract()
            return Std_Wrappers.Result_Success((d_696_cs_).Split())

    @staticmethod
    def Close(cs):
        d_697_valueOrError0_ = (cs).AssertByte(Std_JSON_ZeroCopy_Deserializer_ObjectParams.default__.CLOSE)
        if (d_697_valueOrError0_).IsFailure():
            return (d_697_valueOrError0_).PropagateFailure()
        elif True:
            d_698_cs_ = (d_697_valueOrError0_).Extract()
            return Std_Wrappers.Result_Success((d_698_cs_).Split())

    @staticmethod
    def BracketedFromParts(open, elems, close):
        d_699_sp_ = Std_JSON_Utils_Cursors.Split_SP(Std_JSON_Grammar.Bracketed_Bracketed((open).t, (elems).t, (close).t), (close).cs)
        return d_699_sp_

    @staticmethod
    def AppendWithSuffix(elems, elem, sep):
        d_700_suffixed_ = Std_JSON_Grammar.Suffixed_Suffixed((elem).t, Std_JSON_Grammar.Maybe_NonEmpty((sep).t))
        d_701_elems_k_ = Std_JSON_Utils_Cursors.Split_SP(((elems).t) + (_dafny.SeqWithoutIsStrInference([d_700_suffixed_])), (sep).cs)
        return d_701_elems_k_

    @staticmethod
    def AppendLast(elems, elem, sep):
        d_702_suffixed_ = Std_JSON_Grammar.Suffixed_Suffixed((elem).t, Std_JSON_Grammar.Maybe_Empty())
        d_703_elems_k_ = Std_JSON_Utils_Cursors.Split_SP(((elems).t) + (_dafny.SeqWithoutIsStrInference([d_702_suffixed_])), (elem).cs)
        return d_703_elems_k_

    @staticmethod
    def Elements(json, open, elems):
        while True:
            with _dafny.label():
                d_704_valueOrError0_ = Std_JSON_ZeroCopy_Deserializer_ObjectParams.default__.Element((elems).cs, json)
                if (d_704_valueOrError0_).IsFailure():
                    return (d_704_valueOrError0_).PropagateFailure()
                elif True:
                    d_705_elem_ = (d_704_valueOrError0_).Extract()
                    if ((d_705_elem_).cs).EOF_q:
                        return Std_Wrappers.Result_Failure(Std_JSON_Utils_Cursors.CursorError_EOF())
                    elif True:
                        d_706_sep_ = Std_JSON_ZeroCopy_Deserializer_Core.default__.TryStructural((d_705_elem_).cs)
                        d_707_s0_ = (((d_706_sep_).t).t).Peek()
                        if ((d_707_s0_) == (default__.SEPARATOR)) and (((((d_706_sep_).t).t).Length()) == (1)):
                            d_708_sep_ = d_706_sep_
                            d_709_elems_ = default__.AppendWithSuffix(elems, d_705_elem_, d_708_sep_)
                            in97_ = json
                            in98_ = open
                            in99_ = d_709_elems_
                            json = in97_
                            open = in98_
                            elems = in99_
                            raise _dafny.TailCall()
                        elif ((d_707_s0_) == (Std_JSON_ZeroCopy_Deserializer_ObjectParams.default__.CLOSE)) and (((((d_706_sep_).t).t).Length()) == (1)):
                            d_710_sep_ = d_706_sep_
                            d_711_elems_k_ = default__.AppendLast(elems, d_705_elem_, d_710_sep_)
                            d_712_bracketed_ = default__.BracketedFromParts(open, d_711_elems_k_, d_710_sep_)
                            return Std_Wrappers.Result_Success(d_712_bracketed_)
                        elif True:
                            d_713_separator_ = default__.SEPARATOR
                            d_714_pr_ = Std_Wrappers.Result_Failure(Std_JSON_Utils_Cursors.CursorError_ExpectingAnyByte(_dafny.SeqWithoutIsStrInference([Std_JSON_ZeroCopy_Deserializer_ObjectParams.default__.CLOSE, d_713_separator_]), d_707_s0_))
                            return d_714_pr_
                break

    @staticmethod
    def Bracketed(cs, json):
        d_715_valueOrError0_ = Std_JSON_ZeroCopy_Deserializer_Core.default__.Structural(cs, default__.Open)
        if (d_715_valueOrError0_).IsFailure():
            return (d_715_valueOrError0_).PropagateFailure()
        elif True:
            d_716_open_ = (d_715_valueOrError0_).Extract()
            d_717_elems_ = Std_JSON_Utils_Cursors.Split_SP(_dafny.SeqWithoutIsStrInference([]), (d_716_open_).cs)
            if (((d_716_open_).cs).Peek()) == (Std_JSON_ZeroCopy_Deserializer_ObjectParams.default__.CLOSE):
                d_718_p_ = default__.Close
                d_719_valueOrError1_ = Std_JSON_ZeroCopy_Deserializer_Core.default__.Structural((d_716_open_).cs, d_718_p_)
                if (d_719_valueOrError1_).IsFailure():
                    return (d_719_valueOrError1_).PropagateFailure()
                elif True:
                    d_720_close_ = (d_719_valueOrError1_).Extract()
                    return Std_Wrappers.Result_Success(default__.BracketedFromParts(d_716_open_, d_717_elems_, d_720_close_))
            elif True:
                return default__.Elements(json, d_716_open_, d_717_elems_)

    @_dafny.classproperty
    def SpecViewOpen(instance):
        return Std_JSON_ZeroCopy_Deserializer_Core.default__.SpecView
    @_dafny.classproperty
    def SpecViewClose(instance):
        return Std_JSON_ZeroCopy_Deserializer_Core.default__.SpecView
    @_dafny.classproperty
    def SEPARATOR(instance):
        return ord(_dafny.CodePoint(','))

class jopen:
    def  __init__(self):
        pass

    @staticmethod
    def default():
        return Std_JSON_Utils_Views_Core.View__.OfBytes(_dafny.SeqWithoutIsStrInference([Std_JSON_ZeroCopy_Deserializer_ObjectParams.default__.OPEN]))

class jclose:
    def  __init__(self):
        pass

    @staticmethod
    def default():
        return Std_JSON_Utils_Views_Core.View__.OfBytes(_dafny.SeqWithoutIsStrInference([Std_JSON_ZeroCopy_Deserializer_ObjectParams.default__.CLOSE]))
