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

# Module: Std_JSON_Utils_Cursors


class Split:
    @classmethod
    def default(cls, default_T):
        return lambda: Split_SP(default_T(), FreshCursor.default())
    def __ne__(self, __o: object) -> bool:
        return not self.__eq__(__o)
    @property
    def is_SP(self) -> bool:
        return isinstance(self, Split_SP)

class Split_SP(Split, NamedTuple('SP', [('t', Any), ('cs', Any)])):
    def __dafnystr__(self) -> str:
        return f'Cursors.Split.SP({_dafny.string_of(self.t)}, {_dafny.string_of(self.cs)})'
    def __eq__(self, __o: object) -> bool:
        return isinstance(__o, Split_SP) and self.t == __o.t and self.cs == __o.cs
    def __hash__(self) -> int:
        return super().__hash__()


class Cursor:
    def  __init__(self):
        pass

    @staticmethod
    def default():
        return Cursor___Cursor(_dafny.SeqWithoutIsStrInference([]), 0, 0, 0)

class FreshCursor:
    def  __init__(self):
        pass

    @staticmethod
    def default():
        return Cursor___Cursor(_dafny.SeqWithoutIsStrInference([]), 0, 0, 0)

class CursorError:
    @classmethod
    def default(cls, ):
        return lambda: CursorError_EOF()
    def __ne__(self, __o: object) -> bool:
        return not self.__eq__(__o)
    @property
    def is_EOF(self) -> bool:
        return isinstance(self, CursorError_EOF)
    @property
    def is_ExpectingByte(self) -> bool:
        return isinstance(self, CursorError_ExpectingByte)
    @property
    def is_ExpectingAnyByte(self) -> bool:
        return isinstance(self, CursorError_ExpectingAnyByte)
    @property
    def is_OtherError(self) -> bool:
        return isinstance(self, CursorError_OtherError)
    def ToString(self, pr):
        source14_ = self
        if source14_.is_EOF:
            return _dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "Reached EOF"))
        elif source14_.is_ExpectingByte:
            d_375___mcc_h0_ = source14_.expected
            d_376___mcc_h1_ = source14_.b
            d_377_b_ = d_376___mcc_h1_
            d_378_b0_ = d_375___mcc_h0_
            d_379_c_ = (((_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "'"))) + (_dafny.SeqWithoutIsStrInference([_dafny.CodePoint(chr(d_377_b_))]))) + (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "'"))) if (d_377_b_) > (0) else _dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "EOF")))
            return (((_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "Expecting '"))) + (_dafny.SeqWithoutIsStrInference([_dafny.CodePoint(chr(d_378_b0_))]))) + (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "', read ")))) + (d_379_c_)
        elif source14_.is_ExpectingAnyByte:
            d_380___mcc_h2_ = source14_.expected__sq
            d_381___mcc_h3_ = source14_.b
            d_382_b_ = d_381___mcc_h3_
            d_383_bs0_ = d_380___mcc_h2_
            d_384_c_ = (((_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "'"))) + (_dafny.SeqWithoutIsStrInference([_dafny.CodePoint(chr(d_382_b_))]))) + (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "'"))) if (d_382_b_) > (0) else _dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "EOF")))
            d_385_c0s_ = _dafny.SeqWithoutIsStrInference([_dafny.CodePoint(chr((d_383_bs0_)[d_386_idx_])) for d_386_idx_ in range(len(d_383_bs0_))])
            return (((_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "Expecting one of '"))) + (d_385_c0s_)) + (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "', read ")))) + (d_384_c_)
        elif True:
            d_387___mcc_h4_ = source14_.err
            d_388_err_ = d_387___mcc_h4_
            return pr(d_388_err_)


class CursorError_EOF(CursorError, NamedTuple('EOF', [])):
    def __dafnystr__(self) -> str:
        return f'Cursors.CursorError.EOF'
    def __eq__(self, __o: object) -> bool:
        return isinstance(__o, CursorError_EOF)
    def __hash__(self) -> int:
        return super().__hash__()

class CursorError_ExpectingByte(CursorError, NamedTuple('ExpectingByte', [('expected', Any), ('b', Any)])):
    def __dafnystr__(self) -> str:
        return f'Cursors.CursorError.ExpectingByte({_dafny.string_of(self.expected)}, {_dafny.string_of(self.b)})'
    def __eq__(self, __o: object) -> bool:
        return isinstance(__o, CursorError_ExpectingByte) and self.expected == __o.expected and self.b == __o.b
    def __hash__(self) -> int:
        return super().__hash__()

class CursorError_ExpectingAnyByte(CursorError, NamedTuple('ExpectingAnyByte', [('expected__sq', Any), ('b', Any)])):
    def __dafnystr__(self) -> str:
        return f'Cursors.CursorError.ExpectingAnyByte({_dafny.string_of(self.expected__sq)}, {_dafny.string_of(self.b)})'
    def __eq__(self, __o: object) -> bool:
        return isinstance(__o, CursorError_ExpectingAnyByte) and self.expected__sq == __o.expected__sq and self.b == __o.b
    def __hash__(self) -> int:
        return super().__hash__()

class CursorError_OtherError(CursorError, NamedTuple('OtherError', [('err', Any)])):
    def __dafnystr__(self) -> str:
        return f'Cursors.CursorError.OtherError({_dafny.string_of(self.err)})'
    def __eq__(self, __o: object) -> bool:
        return isinstance(__o, CursorError_OtherError) and self.err == __o.err
    def __hash__(self) -> int:
        return super().__hash__()


class Cursor__:
    @classmethod
    def default(cls, ):
        return lambda: Cursor___Cursor(_dafny.Seq({}), int(0), int(0), int(0))
    def __ne__(self, __o: object) -> bool:
        return not self.__eq__(__o)
    @property
    def is_Cursor(self) -> bool:
        return isinstance(self, Cursor___Cursor)
    @staticmethod
    def OfView(v):
        return Cursor___Cursor((v).s, (v).beg, (v).beg, (v).end)

    @staticmethod
    def OfBytes(bs):
        return Cursor___Cursor(bs, 0, 0, len(bs))

    def Bytes(self):
        return _dafny.SeqWithoutIsStrInference(((self).s)[(self).beg:(self).end:])

    def Prefix(self):
        return Std_JSON_Utils_Views_Core.View___View((self).s, (self).beg, (self).point)

    def Suffix(self):
        d_389_dt__update__tmp_h0_ = self
        d_390_dt__update_hbeg_h0_ = (self).point
        return Cursor___Cursor((d_389_dt__update__tmp_h0_).s, d_390_dt__update_hbeg_h0_, (d_389_dt__update__tmp_h0_).point, (d_389_dt__update__tmp_h0_).end)

    def Split(self):
        return Split_SP((self).Prefix(), (self).Suffix())

    def PrefixLength(self):
        return ((self).point) - ((self).beg)

    def SuffixLength(self):
        return ((self).end) - ((self).point)

    def Length(self):
        return ((self).end) - ((self).beg)

    def At(self, idx):
        return ((self).s)[((self).beg) + (idx)]

    def SuffixAt(self, idx):
        return ((self).s)[((self).point) + (idx)]

    def Peek(self):
        if (self).EOF_q:
            return -1
        elif True:
            return (self).SuffixAt(0)

    def LookingAt(self, c):
        return ((self).Peek()) == (ord(c))

    def Skip(self, n):
        d_391_dt__update__tmp_h0_ = self
        d_392_dt__update_hpoint_h0_ = ((self).point) + (n)
        return Cursor___Cursor((d_391_dt__update__tmp_h0_).s, (d_391_dt__update__tmp_h0_).beg, d_392_dt__update_hpoint_h0_, (d_391_dt__update__tmp_h0_).end)

    def Unskip(self, n):
        d_393_dt__update__tmp_h0_ = self
        d_394_dt__update_hpoint_h0_ = ((self).point) - (n)
        return Cursor___Cursor((d_393_dt__update__tmp_h0_).s, (d_393_dt__update__tmp_h0_).beg, d_394_dt__update_hpoint_h0_, (d_393_dt__update__tmp_h0_).end)

    def Get(self, err):
        if (self).EOF_q:
            return Std_Wrappers.Result_Failure(CursorError_OtherError(err))
        elif True:
            return Std_Wrappers.Result_Success((self).Skip(1))

    def AssertByte(self, b):
        d_395_nxt_ = (self).Peek()
        if (d_395_nxt_) == (b):
            return Std_Wrappers.Result_Success((self).Skip(1))
        elif True:
            return Std_Wrappers.Result_Failure(CursorError_ExpectingByte(b, d_395_nxt_))

    def AssertBytes(self, bs, offset):
        _this = self
        while True:
            with _dafny.label():
                if (offset) == (len(bs)):
                    return Std_Wrappers.Result_Success(_this)
                elif True:
                    d_396_valueOrError0_ = (_this).AssertByte((bs)[offset])
                    if (d_396_valueOrError0_).IsFailure():
                        return (d_396_valueOrError0_).PropagateFailure()
                    elif True:
                        d_397_ps_ = (d_396_valueOrError0_).Extract()
                        in70_ = d_397_ps_
                        in71_ = bs
                        in72_ = (offset) + (1)
                        _this = in70_
                        
                        bs = in71_
                        offset = in72_
                        raise _dafny.TailCall()
                break

    def AssertChar(self, c0):
        return (self).AssertByte(ord(c0))

    def SkipByte(self):
        if (self).EOF_q:
            return self
        elif True:
            return (self).Skip(1)

    def SkipIf(self, p):
        if ((self).EOF_q) or (not(p((self).SuffixAt(0)))):
            return self
        elif True:
            return (self).Skip(1)

    def SkipWhile(self, p):
        ps: Cursor__ = Cursor.default()
        d_398_point_k_: int
        d_398_point_k_ = (self).point
        d_399_end_: int
        d_399_end_ = (self).end
        while ((d_398_point_k_) < (d_399_end_)) and (p(((self).s)[d_398_point_k_])):
            d_398_point_k_ = (d_398_point_k_) + (1)
        ps = Cursor___Cursor((self).s, (self).beg, d_398_point_k_, (self).end)
        return ps
        return ps

    def SkipWhileLexer(self, step, st):
        pr: Std_Wrappers.Result = Std_Wrappers.Result.default(Cursor.default)()
        d_400_point_k_: int
        d_400_point_k_ = (self).point
        d_401_end_: int
        d_401_end_ = (self).end
        d_402_st_k_: TypeVar('A__')
        d_402_st_k_ = st
        while True:
            d_403_eof_: bool
            d_403_eof_ = (d_400_point_k_) == (d_401_end_)
            d_404_minusone_: int
            d_404_minusone_ = -1
            d_405_c_: int
            d_405_c_ = (d_404_minusone_ if d_403_eof_ else ((self).s)[d_400_point_k_])
            source15_ = step(d_402_st_k_, d_405_c_)
            if source15_.is_Accept:
                pr = Std_Wrappers.Result_Success(Cursor___Cursor((self).s, (self).beg, d_400_point_k_, (self).end))
                return pr
            elif source15_.is_Reject:
                d_406___mcc_h0_ = source15_.err
                d_407_err_ = d_406___mcc_h0_
                pr = Std_Wrappers.Result_Failure(CursorError_OtherError(d_407_err_))
                return pr
            elif True:
                d_408___mcc_h1_ = source15_.st
                d_409_st_k_k_ = d_408___mcc_h1_
                if d_403_eof_:
                    pr = Std_Wrappers.Result_Failure(CursorError_EOF())
                    return pr
                elif True:
                    d_402_st_k_ = d_409_st_k_k_
                    d_400_point_k_ = (d_400_point_k_) + (1)
        return pr

    @property
    def BOF_q(self):
        return ((self).point) == ((self).beg)
    @property
    def EOF_q(self):
        return ((self).point) == ((self).end)

class Cursor___Cursor(Cursor__, NamedTuple('Cursor', [('s', Any), ('beg', Any), ('point', Any), ('end', Any)])):
    def __dafnystr__(self) -> str:
        return f'Cursors.Cursor_.Cursor({_dafny.string_of(self.s)}, {_dafny.string_of(self.beg)}, {_dafny.string_of(self.point)}, {_dafny.string_of(self.end)})'
    def __eq__(self, __o: object) -> bool:
        return isinstance(__o, Cursor___Cursor) and self.s == __o.s and self.beg == __o.beg and self.point == __o.point and self.end == __o.end
    def __hash__(self) -> int:
        return super().__hash__()

