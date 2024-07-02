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
import Std_JSON_ZeroCopy_Deserializer_Objects
import Std_JSON_ZeroCopy_Deserializer_ArrayParams

# Module: Std_JSON_ZeroCopy_Deserializer_Arrays

class default__:
    def  __init__(self):
        pass

    @staticmethod
    def Array(cs, json):
        d_721_valueOrError0_ = default__.Bracketed(cs, json)
        if (d_721_valueOrError0_).IsFailure():
            return (d_721_valueOrError0_).PropagateFailure()
        elif True:
            d_722_sp_ = (d_721_valueOrError0_).Extract()
            return Std_Wrappers.Result_Success(d_722_sp_)

    @staticmethod
    def Open(cs):
        d_723_valueOrError0_ = (cs).AssertByte(Std_JSON_ZeroCopy_Deserializer_ArrayParams.default__.OPEN)
        if (d_723_valueOrError0_).IsFailure():
            return (d_723_valueOrError0_).PropagateFailure()
        elif True:
            d_724_cs_ = (d_723_valueOrError0_).Extract()
            return Std_Wrappers.Result_Success((d_724_cs_).Split())

    @staticmethod
    def Close(cs):
        d_725_valueOrError0_ = (cs).AssertByte(Std_JSON_ZeroCopy_Deserializer_ArrayParams.default__.CLOSE)
        if (d_725_valueOrError0_).IsFailure():
            return (d_725_valueOrError0_).PropagateFailure()
        elif True:
            d_726_cs_ = (d_725_valueOrError0_).Extract()
            return Std_Wrappers.Result_Success((d_726_cs_).Split())

    @staticmethod
    def BracketedFromParts(open, elems, close):
        d_727_sp_ = Std_JSON_Utils_Cursors.Split_SP(Std_JSON_Grammar.Bracketed_Bracketed((open).t, (elems).t, (close).t), (close).cs)
        return d_727_sp_

    @staticmethod
    def AppendWithSuffix(elems, elem, sep):
        d_728_suffixed_ = Std_JSON_Grammar.Suffixed_Suffixed((elem).t, Std_JSON_Grammar.Maybe_NonEmpty((sep).t))
        d_729_elems_k_ = Std_JSON_Utils_Cursors.Split_SP(((elems).t) + (_dafny.SeqWithoutIsStrInference([d_728_suffixed_])), (sep).cs)
        return d_729_elems_k_

    @staticmethod
    def AppendLast(elems, elem, sep):
        d_730_suffixed_ = Std_JSON_Grammar.Suffixed_Suffixed((elem).t, Std_JSON_Grammar.Maybe_Empty())
        d_731_elems_k_ = Std_JSON_Utils_Cursors.Split_SP(((elems).t) + (_dafny.SeqWithoutIsStrInference([d_730_suffixed_])), (elem).cs)
        return d_731_elems_k_

    @staticmethod
    def Elements(json, open, elems):
        while True:
            with _dafny.label():
                d_732_valueOrError0_ = Std_JSON_ZeroCopy_Deserializer_ArrayParams.default__.Element((elems).cs, json)
                if (d_732_valueOrError0_).IsFailure():
                    return (d_732_valueOrError0_).PropagateFailure()
                elif True:
                    d_733_elem_ = (d_732_valueOrError0_).Extract()
                    if ((d_733_elem_).cs).EOF_q:
                        return Std_Wrappers.Result_Failure(Std_JSON_Utils_Cursors.CursorError_EOF())
                    elif True:
                        d_734_sep_ = Std_JSON_ZeroCopy_Deserializer_Core.default__.TryStructural((d_733_elem_).cs)
                        d_735_s0_ = (((d_734_sep_).t).t).Peek()
                        if ((d_735_s0_) == (default__.SEPARATOR)) and (((((d_734_sep_).t).t).Length()) == (1)):
                            d_736_sep_ = d_734_sep_
                            d_737_elems_ = default__.AppendWithSuffix(elems, d_733_elem_, d_736_sep_)
                            in100_ = json
                            in101_ = open
                            in102_ = d_737_elems_
                            json = in100_
                            open = in101_
                            elems = in102_
                            raise _dafny.TailCall()
                        elif ((d_735_s0_) == (Std_JSON_ZeroCopy_Deserializer_ArrayParams.default__.CLOSE)) and (((((d_734_sep_).t).t).Length()) == (1)):
                            d_738_sep_ = d_734_sep_
                            d_739_elems_k_ = default__.AppendLast(elems, d_733_elem_, d_738_sep_)
                            d_740_bracketed_ = default__.BracketedFromParts(open, d_739_elems_k_, d_738_sep_)
                            return Std_Wrappers.Result_Success(d_740_bracketed_)
                        elif True:
                            d_741_separator_ = default__.SEPARATOR
                            d_742_pr_ = Std_Wrappers.Result_Failure(Std_JSON_Utils_Cursors.CursorError_ExpectingAnyByte(_dafny.SeqWithoutIsStrInference([Std_JSON_ZeroCopy_Deserializer_ArrayParams.default__.CLOSE, d_741_separator_]), d_735_s0_))
                            return d_742_pr_
                break

    @staticmethod
    def Bracketed(cs, json):
        d_743_valueOrError0_ = Std_JSON_ZeroCopy_Deserializer_Core.default__.Structural(cs, default__.Open)
        if (d_743_valueOrError0_).IsFailure():
            return (d_743_valueOrError0_).PropagateFailure()
        elif True:
            d_744_open_ = (d_743_valueOrError0_).Extract()
            d_745_elems_ = Std_JSON_Utils_Cursors.Split_SP(_dafny.SeqWithoutIsStrInference([]), (d_744_open_).cs)
            if (((d_744_open_).cs).Peek()) == (Std_JSON_ZeroCopy_Deserializer_ArrayParams.default__.CLOSE):
                d_746_p_ = default__.Close
                d_747_valueOrError1_ = Std_JSON_ZeroCopy_Deserializer_Core.default__.Structural((d_744_open_).cs, d_746_p_)
                if (d_747_valueOrError1_).IsFailure():
                    return (d_747_valueOrError1_).PropagateFailure()
                elif True:
                    d_748_close_ = (d_747_valueOrError1_).Extract()
                    return Std_Wrappers.Result_Success(default__.BracketedFromParts(d_744_open_, d_745_elems_, d_748_close_))
            elif True:
                return default__.Elements(json, d_744_open_, d_745_elems_)

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
        return Std_JSON_Utils_Views_Core.View__.OfBytes(_dafny.SeqWithoutIsStrInference([Std_JSON_ZeroCopy_Deserializer_ArrayParams.default__.OPEN]))

class jclose:
    def  __init__(self):
        pass

    @staticmethod
    def default():
        return Std_JSON_Utils_Views_Core.View__.OfBytes(_dafny.SeqWithoutIsStrInference([Std_JSON_ZeroCopy_Deserializer_ArrayParams.default__.CLOSE]))
