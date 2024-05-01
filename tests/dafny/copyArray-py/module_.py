import sys
from itertools import count
from math import floor
from typing import Any, Callable, NamedTuple, TypeVar

import _dafny
import module_
import System_

# Module: module_

class default__:
    def  __init__(self):
        pass

    @staticmethod
    def CopyArray(source, destination):
        d_0_n_: int
        d_0_n_ = 0
        while (d_0_n_) != ((source).length(0)):
            (destination)[(d_0_n_)] = (source)[d_0_n_]
            d_0_n_ = (d_0_n_) + (1)
        print(f"d_0_n {destination}")
