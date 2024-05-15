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

# Module: ReadBytesFromFile

class default__:
    def  __init__(self):
        pass

    @staticmethod
    def Test():
        default__.theMain(_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "/Users/pari/pcc-llms/tests/dafny/FileIOLib/examples/data.txt")), _dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "")))

    @staticmethod
    def theMain(dataPath, expectedErrorPrefix):
        if True:
            d_808_expectedStr_: _dafny.Seq
            d_808_expectedStr_ = _dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "Hello world\nGoodbye\n"))
            d_809_expectedBytes_: _dafny.Seq
            d_809_expectedBytes_ = _dafny.SeqWithoutIsStrInference([ord((d_808_expectedStr_)[d_810_i_]) for d_810_i_ in range(len(d_808_expectedStr_))])
            d_811_res_: Std_Wrappers.Result
            out13_: Std_Wrappers.Result
            out13_ = Std_FileIO.default__.ReadBytesFromFile(dataPath)
            d_811_res_ = out13_
            if not((d_811_res_).is_Success):
                raise _dafny.HaltException("tests/dafny/FileIOLib/examples/ReadBytesFromFile.dfy(23,6): " + ((_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "unexpected failure: "))) + ((d_811_res_).error)).VerbatimString(False))
            d_812_readBytes_: _dafny.Seq
            d_812_readBytes_ = _dafny.SeqWithoutIsStrInference([((d_811_res_).value)[d_813_i_] for d_813_i_ in range(len((d_811_res_).value))])
            if not((d_812_readBytes_) == (d_809_expectedBytes_)):
                raise _dafny.HaltException("tests/dafny/FileIOLib/examples/ReadBytesFromFile.dfy(26,6): " + (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "read unexpected byte sequence"))).VerbatimString(False))
        if True:
            d_814_res_: Std_Wrappers.Result
            out14_: Std_Wrappers.Result
            out14_ = Std_FileIO.default__.ReadBytesFromFile(_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "")))
            d_814_res_ = out14_
            if not((d_814_res_).is_Failure):
                raise _dafny.HaltException("tests/dafny/FileIOLib/examples/ReadBytesFromFile.dfy(32,6): " + (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "unexpected success"))).VerbatimString(False))
            if not((expectedErrorPrefix) <= ((d_814_res_).error)):
                raise _dafny.HaltException("tests/dafny/FileIOLib/examples/ReadBytesFromFile.dfy(33,6): " + ((_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "unexpected error message: "))) + ((d_814_res_).error)).VerbatimString(False))

    @staticmethod
    def Main(noArgsParameter__):
        _dafny.print((_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "Read Bytes \n"))).VerbatimString(False))

