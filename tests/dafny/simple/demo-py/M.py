import sys
from typing import Callable, Any, TypeVar, NamedTuple
from math import floor
from itertools import count

import module_
import _dafny
import System_

# Module: M


class C:
    def  __init__(self):
        pass

    def __dafnystr__(self) -> str:
        return "M.C"
    @staticmethod
    def p():
        _dafny.print((_dafny.SeqWithoutIsStrInference(map(_dafny.CodePoint, "Hello, World\n"))).VerbatimString(False))

