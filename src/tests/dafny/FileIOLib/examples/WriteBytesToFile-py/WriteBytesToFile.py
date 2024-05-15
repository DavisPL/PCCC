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
import Std_JSON_ZeroCopy_Deserializer_Arrays
import Std_JSON_ZeroCopy_Deserializer_Constants
import Std_JSON_ZeroCopy_Deserializer_Values
import Std_JSON_ZeroCopy_Deserializer_API
import Std_JSON_ZeroCopy_Deserializer
import Std_JSON_ZeroCopy_API
import Std_JSON_ZeroCopy
import Std_JSON_API
import Std_JSON
import Std

# Module: WriteBytesToFile

class default__:
    def  __init__(self):
        pass

    @staticmethod
    def Test():
        default__.theMain(_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "build/../build/fileioexamples")), _dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "")))

    @staticmethod
    def theMain(outputDir, expectedErrorPrefix):
        if True:
            d_808_bytes_: _dafny.Seq
            d_808_bytes_ = _dafny.SeqWithoutIsStrInference([72, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 10, 71, 111, 111, 100, 98, 121, 101, 10])
            if True:
                d_809_res_: Std_Wrappers.Result
                out13_: Std_Wrappers.Result
                out13_ = Std_FileIO.default__.WriteBytesToFile((outputDir) + (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "/output_plain"))), d_808_bytes_)
                d_809_res_ = out13_
                if not((d_809_res_).is_Success):
                    raise _dafny.HaltException("tests/dafny/FileIOLib/examples/WriteBytesToFile.dfy(122,8): " + ((_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "unexpected failure writing to output_plain: "))) + ((d_809_res_).error)).VerbatimString(False))
            if True:
                d_810_res_: Std_Wrappers.Result
                out14_: Std_Wrappers.Result
                out14_ = Std_FileIO.default__.WriteBytesToFile((outputDir) + (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "/foo/bar/output_nested"))), d_808_bytes_)
                d_810_res_ = out14_
                if not((d_810_res_).is_Success):
                    raise _dafny.HaltException("tests/dafny/FileIOLib/examples/WriteBytesToFile.dfy(127,8): " + ((_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "unexpected failure writing to output_nested: "))) + ((d_810_res_).error)).VerbatimString(False))
            if True:
                d_811_res_: Std_Wrappers.Result
                out15_: Std_Wrappers.Result
                out15_ = Std_FileIO.default__.WriteBytesToFile((outputDir) + (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "/foo/bar/../output_up"))), d_808_bytes_)
                d_811_res_ = out15_
                if not((d_811_res_).is_Success):
                    raise _dafny.HaltException("tests/dafny/FileIOLib/examples/WriteBytesToFile.dfy(132,8): " + ((_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "unexpected failure writing to output_up: "))) + ((d_811_res_).error)).VerbatimString(False))
        if True:
            d_812_res_: Std_Wrappers.Result
            out16_: Std_Wrappers.Result
            out16_ = Std_FileIO.default__.WriteBytesToFile(_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "")), _dafny.SeqWithoutIsStrInference([]))
            d_812_res_ = out16_
            if not((d_812_res_).is_Failure):
                raise _dafny.HaltException("tests/dafny/FileIOLib/examples/WriteBytesToFile.dfy(139,6): " + (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "unexpected success"))).VerbatimString(False))
            if not((expectedErrorPrefix) <= ((d_812_res_).error)):
                raise _dafny.HaltException("tests/dafny/FileIOLib/examples/WriteBytesToFile.dfy(140,6): " + ((_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "unexpected error message: "))) + ((d_812_res_).error)).VerbatimString(False))

