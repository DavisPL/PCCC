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
import WriteBytesToFile

# Module: module_

class default__:
    def  __init__(self):
        pass

    @staticmethod
    def Test____Main____(noArgsParameter__):
        d_813_success_: bool
        d_813_success_ = True
        _dafny.print((_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "WriteBytesToFile.Test: "))).VerbatimString(False))
        try:
            if True:
                WriteBytesToFile.default__.Test()
                if True:
                    _dafny.print((_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "PASSED\n"))).VerbatimString(False))
        except _dafny.HaltException as e:
            d_814_haltMessage_ = _dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, e.message))
            if True:
                _dafny.print((_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "FAILED\n	"))).VerbatimString(False))
                _dafny.print((d_814_haltMessage_).VerbatimString(False))
                _dafny.print((_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "\n"))).VerbatimString(False))
                d_813_success_ = False
        if not(d_813_success_):
            raise _dafny.HaltException("tests/dafny/FileIOLib/examples/WriteBytesToFile.dfy(93,0): " + (_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "Test failures occurred: see above.\n"))).VerbatimString(False))

