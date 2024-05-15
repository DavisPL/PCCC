# Dafny program test.dfy compiled into Python
import sys
from typing import Callable, Any, TypeVar, NamedTuple
from math import floor
from itertools import count

import module_
import _dafny

try:
    dafnyArgs = [_dafny.Seq(a) for a in sys.argv]
    module_.default__.Main(dafnyArgs)
except _dafny.HaltException as e:
    _dafny.print("[Program halted] " + e.message + "\n")
    sys.exit(1)
