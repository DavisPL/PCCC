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

# Module: Std_JSON_ZeroCopy_Serializer

class default__:
    def  __init__(self):
        pass

    @staticmethod
    def Serialize(js):
        rbs: Std_Wrappers.Result = Std_Wrappers.Result.default(_dafny.defaults.pointer)()
        d_576_writer_: Std_JSON_Utils_Views_Writers.Writer__
        d_576_writer_ = default__.Text(js)
        d_577_valueOrError0_: Std_Wrappers.OutcomeResult = Std_Wrappers.OutcomeResult.default()()
        d_577_valueOrError0_ = Std_Wrappers.default__.Need((d_576_writer_).Unsaturated_q, Std_JSON_Errors.SerializationError_OutOfMemory())
        if (d_577_valueOrError0_).IsFailure():
            rbs = (d_577_valueOrError0_).PropagateFailure()
            return rbs
        d_578_bs_: _dafny.Array
        out6_: _dafny.Array
        out6_ = (d_576_writer_).ToArray()
        d_578_bs_ = out6_
        rbs = Std_Wrappers.Result_Success(d_578_bs_)
        return rbs
        return rbs

    @staticmethod
    def SerializeTo(js, dest):
        len: Std_Wrappers.Result = Std_Wrappers.Result.default(Std_BoundedInts.uint32.default)()
        d_579_writer_: Std_JSON_Utils_Views_Writers.Writer__
        d_579_writer_ = default__.Text(js)
        d_580_valueOrError0_: Std_Wrappers.OutcomeResult = Std_Wrappers.OutcomeResult.default()()
        d_580_valueOrError0_ = Std_Wrappers.default__.Need((d_579_writer_).Unsaturated_q, Std_JSON_Errors.SerializationError_OutOfMemory())
        if (d_580_valueOrError0_).IsFailure():
            len = (d_580_valueOrError0_).PropagateFailure()
            return len
        d_581_valueOrError1_: Std_Wrappers.OutcomeResult = Std_Wrappers.OutcomeResult.default()()
        d_581_valueOrError1_ = Std_Wrappers.default__.Need(((d_579_writer_).length) <= ((dest).length(0)), Std_JSON_Errors.SerializationError_OutOfMemory())
        if (d_581_valueOrError1_).IsFailure():
            len = (d_581_valueOrError1_).PropagateFailure()
            return len
        (d_579_writer_).CopyTo(dest)
        len = Std_Wrappers.Result_Success((d_579_writer_).length)
        return len
        return len

    @staticmethod
    def Text(js):
        return default__.JSON(js, Std_JSON_Utils_Views_Writers.Writer__.Empty)

    @staticmethod
    def JSON(js, writer):
        def lambda40_(d_582_js_):
            def lambda41_(d_583_wr_):
                return default__.Value((d_582_js_).t, d_583_wr_)

            return lambda41_

        return (((writer).Append((js).before)).Then(lambda40_(js))).Append((js).after)

    @staticmethod
    def Value(v, writer):
        source23_ = v
        if source23_.is_Null:
            d_584___mcc_h0_ = source23_.n
            d_585_n_ = d_584___mcc_h0_
            d_586_wr_ = (writer).Append(d_585_n_)
            return d_586_wr_
        elif source23_.is_Bool:
            d_587___mcc_h1_ = source23_.b
            d_588_b_ = d_587___mcc_h1_
            d_589_wr_ = (writer).Append(d_588_b_)
            return d_589_wr_
        elif source23_.is_String:
            d_590___mcc_h2_ = source23_.str
            d_591_str_ = d_590___mcc_h2_
            d_592_wr_ = default__.String(d_591_str_, writer)
            return d_592_wr_
        elif source23_.is_Number:
            d_593___mcc_h3_ = source23_.num
            d_594_num_ = d_593___mcc_h3_
            d_595_wr_ = default__.Number(d_594_num_, writer)
            return d_595_wr_
        elif source23_.is_Object:
            d_596___mcc_h4_ = source23_.obj
            d_597_obj_ = d_596___mcc_h4_
            d_598_wr_ = default__.Object(d_597_obj_, writer)
            return d_598_wr_
        elif True:
            d_599___mcc_h5_ = source23_.arr
            d_600_arr_ = d_599___mcc_h5_
            d_601_wr_ = default__.Array(d_600_arr_, writer)
            return d_601_wr_

    @staticmethod
    def String(str, writer):
        return (((writer).Append((str).lq)).Append((str).contents)).Append((str).rq)

    @staticmethod
    def Number(num, writer):
        d_602_wr1_ = ((writer).Append((num).minus)).Append((num).num)
        d_603_wr2_ = (((d_602_wr1_).Append((((num).frac).t).period)).Append((((num).frac).t).num) if ((num).frac).is_NonEmpty else d_602_wr1_)
        d_604_wr3_ = ((((d_603_wr2_).Append((((num).exp).t).e)).Append((((num).exp).t).sign)).Append((((num).exp).t).num) if ((num).exp).is_NonEmpty else d_603_wr2_)
        d_605_wr_ = d_604_wr3_
        return d_605_wr_

    @staticmethod
    def StructuralView(st, writer):
        return (((writer).Append((st).before)).Append((st).t)).Append((st).after)

    @staticmethod
    def Object(obj, writer):
        d_606_wr_ = default__.StructuralView((obj).l, writer)
        d_607_wr_ = default__.Members(obj, d_606_wr_)
        d_608_wr_ = default__.StructuralView((obj).r, d_607_wr_)
        return d_608_wr_

    @staticmethod
    def Array(arr, writer):
        d_609_wr_ = default__.StructuralView((arr).l, writer)
        d_610_wr_ = default__.Items(arr, d_609_wr_)
        d_611_wr_ = default__.StructuralView((arr).r, d_610_wr_)
        return d_611_wr_

    @staticmethod
    def Members(obj, writer):
        wr: Std_JSON_Utils_Views_Writers.Writer__ = Std_JSON_Utils_Views_Writers.Writer.default()
        out7_: Std_JSON_Utils_Views_Writers.Writer__
        out7_ = default__.MembersImpl(obj, writer)
        wr = out7_
        return wr

    @staticmethod
    def Items(arr, writer):
        wr: Std_JSON_Utils_Views_Writers.Writer__ = Std_JSON_Utils_Views_Writers.Writer.default()
        out8_: Std_JSON_Utils_Views_Writers.Writer__
        out8_ = default__.ItemsImpl(arr, writer)
        wr = out8_
        return wr

    @staticmethod
    def MembersImpl(obj, writer):
        wr: Std_JSON_Utils_Views_Writers.Writer__ = Std_JSON_Utils_Views_Writers.Writer.default()
        wr = writer
        d_612_members_: _dafny.Seq
        d_612_members_ = (obj).data
        hi1_ = len(d_612_members_)
        for d_613_i_ in range(0, hi1_):
            wr = default__.Member((d_612_members_)[d_613_i_], wr)
        return wr

    @staticmethod
    def ItemsImpl(arr, writer):
        wr: Std_JSON_Utils_Views_Writers.Writer__ = Std_JSON_Utils_Views_Writers.Writer.default()
        wr = writer
        d_614_items_: _dafny.Seq
        d_614_items_ = (arr).data
        hi2_ = len(d_614_items_)
        for d_615_i_ in range(0, hi2_):
            wr = default__.Item((d_614_items_)[d_615_i_], wr)
        return wr

    @staticmethod
    def Member(m, writer):
        d_616_wr_ = default__.String(((m).t).k, writer)
        d_617_wr_ = default__.StructuralView(((m).t).colon, d_616_wr_)
        d_618_wr_ = default__.Value(((m).t).v, d_617_wr_)
        d_619_wr_ = (d_618_wr_ if ((m).suffix).is_Empty else default__.StructuralView(((m).suffix).t, d_618_wr_))
        return d_619_wr_

    @staticmethod
    def Item(m, writer):
        d_620_wr_ = default__.Value((m).t, writer)
        d_621_wr_ = (d_620_wr_ if ((m).suffix).is_Empty else default__.StructuralView(((m).suffix).t, d_620_wr_))
        return d_621_wr_

