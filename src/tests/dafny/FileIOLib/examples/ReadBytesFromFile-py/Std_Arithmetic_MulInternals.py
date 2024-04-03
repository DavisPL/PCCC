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

# Module: Std_Arithmetic_MulInternals

class default__:
    def  __init__(self):
        pass

    @staticmethod
    def MulPos(x, y):
        d_134___accumulator_ = 0
        while True:
            with _dafny.label():
                if (x) == (0):
                    return (0) + (d_134___accumulator_)
                elif True:
                    d_134___accumulator_ = (d_134___accumulator_) + (y)
                    in32_ = (x) - (1)
                    in33_ = y
                    x = in32_
                    y = in33_
                    raise _dafny.TailCall()
                break

    @staticmethod
    def MulRecursive(x, y):
        if (x) >= (0):
            return default__.MulPos(x, y)
        elif True:
            return (-1) * (default__.MulPos((-1) * (x), y))

