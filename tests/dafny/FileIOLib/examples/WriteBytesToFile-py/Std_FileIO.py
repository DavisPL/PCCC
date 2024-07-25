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

# Module: Std_FileIO

class default__:
    def  __init__(self):
        pass

    @staticmethod
    def ReadBytesFromFile(path):
        res: Std_Wrappers.Result = Std_Wrappers.Result.default(_dafny.Seq)()
        d_28_isError_: bool
        d_29_bytesRead_: _dafny.Seq
        d_30_errorMsg_: _dafny.Seq
        out0_: bool
        out1_: _dafny.Seq
        out2_: _dafny.Seq
        out0_, out1_, out2_ = Std_FileIOInternalExterns.default__.INTERNAL__ReadBytesFromFile(path)
        d_28_isError_ = out0_
        d_29_bytesRead_ = out1_
        d_30_errorMsg_ = out2_
        res = (Std_Wrappers.Result_Failure(d_30_errorMsg_) if d_28_isError_ else Std_Wrappers.Result_Success(d_29_bytesRead_))
        return res
        return res

    @staticmethod
    def WriteBytesToFile(path, bytes):
        res: Std_Wrappers.Result = Std_Wrappers.Result.default(_dafny.defaults.tuple())()
        d_31_isError_: bool
        d_32_errorMsg_: _dafny.Seq
        out3_: bool
        out4_: _dafny.Seq
        out3_, out4_ = Std_FileIOInternalExterns.default__.INTERNAL__WriteBytesToFile(path, bytes)
        d_31_isError_ = out3_
        d_32_errorMsg_ = out4_
        res = (Std_Wrappers.Result_Failure(d_32_errorMsg_) if d_31_isError_ else Std_Wrappers.Result_Success(()))
        return res
        return res

