# Dafny program the_program compiled into Python
import sys
from itertools import count
from math import floor
from typing import Any, Callable, NamedTuple, TypeVar

import _dafny
import module_

try:
    dafnyArgs = [_dafny.Seq(a) for a in sys.argv]
    module_.default__.Test____Main____(dafnyArgs)
except _dafny.HaltException as e:
    _dafny.print("[Program halted] " + e.message + "\n")
    sys.exit(1) 