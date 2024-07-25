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

# Module: Std_Unicode_Utf8EncodingForm

class default__:
    def  __init__(self):
        pass

    @staticmethod
    def IsMinimalWellFormedCodeUnitSubsequence(s):
        if (len(s)) == (1):
            d_185_b_ = default__.IsWellFormedSingleCodeUnitSequence(s)
            return d_185_b_
        elif (len(s)) == (2):
            d_186_b_ = default__.IsWellFormedDoubleCodeUnitSequence(s)
            return d_186_b_
        elif (len(s)) == (3):
            d_187_b_ = default__.IsWellFormedTripleCodeUnitSequence(s)
            return d_187_b_
        elif (len(s)) == (4):
            d_188_b_ = default__.IsWellFormedQuadrupleCodeUnitSequence(s)
            return d_188_b_
        elif True:
            return False

    @staticmethod
    def IsWellFormedSingleCodeUnitSequence(s):
        d_189_firstByte_ = (s)[0]
        return (True) and (((0) <= (d_189_firstByte_)) and ((d_189_firstByte_) <= (127)))

    @staticmethod
    def IsWellFormedDoubleCodeUnitSequence(s):
        d_190_firstByte_ = (s)[0]
        d_191_secondByte_ = (s)[1]
        return (((194) <= (d_190_firstByte_)) and ((d_190_firstByte_) <= (223))) and (((128) <= (d_191_secondByte_)) and ((d_191_secondByte_) <= (191)))

    @staticmethod
    def IsWellFormedTripleCodeUnitSequence(s):
        d_192_firstByte_ = (s)[0]
        d_193_secondByte_ = (s)[1]
        d_194_thirdByte_ = (s)[2]
        return ((((((d_192_firstByte_) == (224)) and (((160) <= (d_193_secondByte_)) and ((d_193_secondByte_) <= (191)))) or ((((225) <= (d_192_firstByte_)) and ((d_192_firstByte_) <= (236))) and (((128) <= (d_193_secondByte_)) and ((d_193_secondByte_) <= (191))))) or (((d_192_firstByte_) == (237)) and (((128) <= (d_193_secondByte_)) and ((d_193_secondByte_) <= (159))))) or ((((238) <= (d_192_firstByte_)) and ((d_192_firstByte_) <= (239))) and (((128) <= (d_193_secondByte_)) and ((d_193_secondByte_) <= (191))))) and (((128) <= (d_194_thirdByte_)) and ((d_194_thirdByte_) <= (191)))

    @staticmethod
    def IsWellFormedQuadrupleCodeUnitSequence(s):
        d_195_firstByte_ = (s)[0]
        d_196_secondByte_ = (s)[1]
        d_197_thirdByte_ = (s)[2]
        d_198_fourthByte_ = (s)[3]
        return ((((((d_195_firstByte_) == (240)) and (((144) <= (d_196_secondByte_)) and ((d_196_secondByte_) <= (191)))) or ((((241) <= (d_195_firstByte_)) and ((d_195_firstByte_) <= (243))) and (((128) <= (d_196_secondByte_)) and ((d_196_secondByte_) <= (191))))) or (((d_195_firstByte_) == (244)) and (((128) <= (d_196_secondByte_)) and ((d_196_secondByte_) <= (143))))) and (((128) <= (d_197_thirdByte_)) and ((d_197_thirdByte_) <= (191)))) and (((128) <= (d_198_fourthByte_)) and ((d_198_fourthByte_) <= (191)))

    @staticmethod
    def SplitPrefixMinimalWellFormedCodeUnitSubsequence(s):
        if ((len(s)) >= (1)) and (default__.IsWellFormedSingleCodeUnitSequence(_dafny.SeqWithoutIsStrInference((s)[:1:]))):
            return Std_Wrappers.Option_Some(_dafny.SeqWithoutIsStrInference((s)[:1:]))
        elif ((len(s)) >= (2)) and (default__.IsWellFormedDoubleCodeUnitSequence(_dafny.SeqWithoutIsStrInference((s)[:2:]))):
            return Std_Wrappers.Option_Some(_dafny.SeqWithoutIsStrInference((s)[:2:]))
        elif ((len(s)) >= (3)) and (default__.IsWellFormedTripleCodeUnitSequence(_dafny.SeqWithoutIsStrInference((s)[:3:]))):
            return Std_Wrappers.Option_Some(_dafny.SeqWithoutIsStrInference((s)[:3:]))
        elif ((len(s)) >= (4)) and (default__.IsWellFormedQuadrupleCodeUnitSequence(_dafny.SeqWithoutIsStrInference((s)[:4:]))):
            return Std_Wrappers.Option_Some(_dafny.SeqWithoutIsStrInference((s)[:4:]))
        elif True:
            return Std_Wrappers.Option_None()

    @staticmethod
    def EncodeScalarValue(v):
        if (v) <= (127):
            return default__.EncodeScalarValueSingleByte(v)
        elif (v) <= (2047):
            return default__.EncodeScalarValueDoubleByte(v)
        elif (v) <= (65535):
            return default__.EncodeScalarValueTripleByte(v)
        elif True:
            return default__.EncodeScalarValueQuadrupleByte(v)

    @staticmethod
    def EncodeScalarValueSingleByte(v):
        d_199_x_ = (v) & (127)
        d_200_firstByte_ = d_199_x_
        return _dafny.SeqWithoutIsStrInference([d_200_firstByte_])

    @staticmethod
    def EncodeScalarValueDoubleByte(v):
        d_201_x_ = (v) & (63)
        d_202_y_ = ((v) & (1984)) >> (6)
        d_203_firstByte_ = (192) | (d_202_y_)
        d_204_secondByte_ = (128) | (d_201_x_)
        return _dafny.SeqWithoutIsStrInference([d_203_firstByte_, d_204_secondByte_])

    @staticmethod
    def EncodeScalarValueTripleByte(v):
        d_205_x_ = (v) & (63)
        d_206_y_ = ((v) & (4032)) >> (6)
        d_207_z_ = ((v) & (61440)) >> (12)
        d_208_firstByte_ = (224) | (d_207_z_)
        d_209_secondByte_ = (128) | (d_206_y_)
        d_210_thirdByte_ = (128) | (d_205_x_)
        return _dafny.SeqWithoutIsStrInference([d_208_firstByte_, d_209_secondByte_, d_210_thirdByte_])

    @staticmethod
    def EncodeScalarValueQuadrupleByte(v):
        d_211_x_ = (v) & (63)
        d_212_y_ = ((v) & (4032)) >> (6)
        d_213_z_ = ((v) & (61440)) >> (12)
        d_214_u2_ = ((v) & (196608)) >> (16)
        d_215_u1_ = ((v) & (1835008)) >> (18)
        d_216_firstByte_ = (240) | (d_215_u1_)
        d_217_secondByte_ = ((128) | (((d_214_u2_) << (4)) & ((1 << 8) - 1))) | (d_213_z_)
        d_218_thirdByte_ = (128) | (d_212_y_)
        d_219_fourthByte_ = (128) | (d_211_x_)
        return _dafny.SeqWithoutIsStrInference([d_216_firstByte_, d_217_secondByte_, d_218_thirdByte_, d_219_fourthByte_])

    @staticmethod
    def DecodeMinimalWellFormedCodeUnitSubsequence(m):
        if (len(m)) == (1):
            return default__.DecodeMinimalWellFormedCodeUnitSubsequenceSingleByte(m)
        elif (len(m)) == (2):
            return default__.DecodeMinimalWellFormedCodeUnitSubsequenceDoubleByte(m)
        elif (len(m)) == (3):
            return default__.DecodeMinimalWellFormedCodeUnitSubsequenceTripleByte(m)
        elif True:
            return default__.DecodeMinimalWellFormedCodeUnitSubsequenceQuadrupleByte(m)

    @staticmethod
    def DecodeMinimalWellFormedCodeUnitSubsequenceSingleByte(m):
        d_220_firstByte_ = (m)[0]
        d_221_x_ = d_220_firstByte_
        return d_221_x_

    @staticmethod
    def DecodeMinimalWellFormedCodeUnitSubsequenceDoubleByte(m):
        d_222_firstByte_ = (m)[0]
        d_223_secondByte_ = (m)[1]
        d_224_y_ = (d_222_firstByte_) & (31)
        d_225_x_ = (d_223_secondByte_) & (63)
        return (((d_224_y_) << (6)) & ((1 << 24) - 1)) | (d_225_x_)

    @staticmethod
    def DecodeMinimalWellFormedCodeUnitSubsequenceTripleByte(m):
        d_226_firstByte_ = (m)[0]
        d_227_secondByte_ = (m)[1]
        d_228_thirdByte_ = (m)[2]
        d_229_z_ = (d_226_firstByte_) & (15)
        d_230_y_ = (d_227_secondByte_) & (63)
        d_231_x_ = (d_228_thirdByte_) & (63)
        return ((((d_229_z_) << (12)) & ((1 << 24) - 1)) | (((d_230_y_) << (6)) & ((1 << 24) - 1))) | (d_231_x_)

    @staticmethod
    def DecodeMinimalWellFormedCodeUnitSubsequenceQuadrupleByte(m):
        d_232_firstByte_ = (m)[0]
        d_233_secondByte_ = (m)[1]
        d_234_thirdByte_ = (m)[2]
        d_235_fourthByte_ = (m)[3]
        d_236_u1_ = (d_232_firstByte_) & (7)
        d_237_u2_ = ((d_233_secondByte_) & (48)) >> (4)
        d_238_z_ = (d_233_secondByte_) & (15)
        d_239_y_ = (d_234_thirdByte_) & (63)
        d_240_x_ = (d_235_fourthByte_) & (63)
        return ((((((d_236_u1_) << (18)) & ((1 << 24) - 1)) | (((d_237_u2_) << (16)) & ((1 << 24) - 1))) | (((d_238_z_) << (12)) & ((1 << 24) - 1))) | (((d_239_y_) << (6)) & ((1 << 24) - 1))) | (d_240_x_)

    @staticmethod
    def PartitionCodeUnitSequenceChecked(s):
        maybeParts: Std_Wrappers.Option = Std_Wrappers.Option.default()()
        if (s) == (_dafny.SeqWithoutIsStrInference([])):
            maybeParts = Std_Wrappers.Option_Some(_dafny.SeqWithoutIsStrInference([]))
            return maybeParts
        d_241_result_: _dafny.Seq
        d_241_result_ = _dafny.SeqWithoutIsStrInference([])
        d_242_rest_: _dafny.Seq
        d_242_rest_ = s
        while (len(d_242_rest_)) > (0):
            d_243_prefix_: _dafny.Seq
            d_244_valueOrError0_: Std_Wrappers.Option = Std_Wrappers.Option.default()()
            d_244_valueOrError0_ = default__.SplitPrefixMinimalWellFormedCodeUnitSubsequence(d_242_rest_)
            if (d_244_valueOrError0_).IsFailure():
                maybeParts = (d_244_valueOrError0_).PropagateFailure()
                return maybeParts
            d_243_prefix_ = (d_244_valueOrError0_).Extract()
            d_241_result_ = (d_241_result_) + (_dafny.SeqWithoutIsStrInference([d_243_prefix_]))
            d_242_rest_ = _dafny.SeqWithoutIsStrInference((d_242_rest_)[len(d_243_prefix_)::])
        maybeParts = Std_Wrappers.Option_Some(d_241_result_)
        return maybeParts
        return maybeParts

    @staticmethod
    def PartitionCodeUnitSequence(s):
        return (default__.PartitionCodeUnitSequenceChecked(s)).Extract()

    @staticmethod
    def IsWellFormedCodeUnitSequence(s):
        return (default__.PartitionCodeUnitSequenceChecked(s)).is_Some

    @staticmethod
    def EncodeScalarSequence(vs):
        s: _dafny.Seq = WellFormedCodeUnitSeq.default()
        s = _dafny.SeqWithoutIsStrInference([])
        lo0_ = 0
        for d_245_i_ in range(len(vs)-1, lo0_-1, -1):
            d_246_next_: _dafny.Seq
            d_246_next_ = default__.EncodeScalarValue((vs)[d_245_i_])
            s = (d_246_next_) + (s)
        return s

    @staticmethod
    def DecodeCodeUnitSequence(s):
        d_247_parts_ = default__.PartitionCodeUnitSequence(s)
        d_248_vs_ = Std_Collections_Seq.default__.Map(default__.DecodeMinimalWellFormedCodeUnitSubsequence, d_247_parts_)
        return d_248_vs_

    @staticmethod
    def DecodeCodeUnitSequenceChecked(s):
        maybeVs: Std_Wrappers.Option = Std_Wrappers.Option.default()()
        d_249_maybeParts_: Std_Wrappers.Option
        d_249_maybeParts_ = default__.PartitionCodeUnitSequenceChecked(s)
        if (d_249_maybeParts_).is_None:
            maybeVs = Std_Wrappers.Option_None()
            return maybeVs
        d_250_parts_: _dafny.Seq
        d_250_parts_ = (d_249_maybeParts_).value
        d_251_vs_: _dafny.Seq
        d_251_vs_ = Std_Collections_Seq.default__.Map(default__.DecodeMinimalWellFormedCodeUnitSubsequence, d_250_parts_)
        maybeVs = Std_Wrappers.Option_Some(d_251_vs_)
        return maybeVs
        return maybeVs


class WellFormedCodeUnitSeq:
    def  __init__(self):
        pass

    @staticmethod
    def default():
        return _dafny.SeqWithoutIsStrInference([])
    def _Is(source__):
        d_252_s_: _dafny.Seq = source__
        return default__.IsWellFormedCodeUnitSequence(d_252_s_)

class MinimalWellFormedCodeUnitSeq:
    def  __init__(self):
        pass

    @staticmethod
    def default():
        return _dafny.Seq({})
    def _Is(source__):
        d_253_s_: _dafny.Seq = source__
        return default__.IsMinimalWellFormedCodeUnitSubsequence(d_253_s_)
