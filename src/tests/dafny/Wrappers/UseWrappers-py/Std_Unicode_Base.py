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

# Module: Std_Unicode_Base

class default__:
    def  __init__(self):
        pass

    @staticmethod
    def IsInAssignedPlane(i):
        d_179_plane_ = (i) >> (16)
        return (d_179_plane_) in (default__.ASSIGNED__PLANES)

    @_dafny.classproperty
    def HIGH__SURROGATE__MIN(instance):
        return 55296
    @_dafny.classproperty
    def HIGH__SURROGATE__MAX(instance):
        return 56319
    @_dafny.classproperty
    def LOW__SURROGATE__MIN(instance):
        return 56320
    @_dafny.classproperty
    def LOW__SURROGATE__MAX(instance):
        return 57343
    @_dafny.classproperty
    def ASSIGNED__PLANES(instance):
        return _dafny.Set({0, 1, 2, 3, 14, 15, 16})

class CodePoint:
    def  __init__(self):
        pass

    @staticmethod
    def default():
        return int(0)
    def _Is(source__):
        d_180_i_: int = source__
        return ((0) <= (d_180_i_)) and ((d_180_i_) <= (1114111))

class HighSurrogateCodePoint:
    def  __init__(self):
        pass

    @staticmethod
    def default():
        return default__.HIGH__SURROGATE__MIN
    def _Is(source__):
        d_181_p_: int = source__
        if CodePoint._Is(d_181_p_):
            return ((default__.HIGH__SURROGATE__MIN) <= (d_181_p_)) and ((d_181_p_) <= (default__.HIGH__SURROGATE__MAX))
        return False

class LowSurrogateCodePoint:
    def  __init__(self):
        pass

    @staticmethod
    def default():
        return default__.LOW__SURROGATE__MIN
    def _Is(source__):
        d_182_p_: int = source__
        if CodePoint._Is(d_182_p_):
            return ((default__.LOW__SURROGATE__MIN) <= (d_182_p_)) and ((d_182_p_) <= (default__.LOW__SURROGATE__MAX))
        return False

class ScalarValue:
    def  __init__(self):
        pass

    @staticmethod
    def default():
        return int(0)
    def _Is(source__):
        d_183_p_: int = source__
        if CodePoint._Is(d_183_p_):
            return (((d_183_p_) < (default__.HIGH__SURROGATE__MIN)) or ((d_183_p_) > (default__.HIGH__SURROGATE__MAX))) and (((d_183_p_) < (default__.LOW__SURROGATE__MIN)) or ((d_183_p_) > (default__.LOW__SURROGATE__MAX)))
        return False

class AssignedCodePoint:
    def  __init__(self):
        pass

    @staticmethod
    def default():
        return int(0)
    def _Is(source__):
        d_184_p_: int = source__
        if CodePoint._Is(d_184_p_):
            return default__.IsInAssignedPlane(d_184_p_)
        return False
