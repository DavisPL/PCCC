import sys
from typing import Callable, Any, TypeVar, NamedTuple
from math import floor
from itertools import count

import module_ as module_
import _dafny as _dafny
import System_ as System_
import Wrappers as Wrappers
import Utils as Utils

# Module: FileIO

class default__:
    def  __init__(self):
        pass

    @staticmethod
    def Open(file):
        res: Wrappers.Result = None
        d_0_isError_: bool
        d_1_fileStream_: object
        d_2_errorMsg_: _dafny.Seq
        out0_: bool
        out1_: object
        out2_: _dafny.Seq
        out0_, out1_, out2_ = DafnyLibraries.FileIO.Files.INTERNAL_Open(file)
        d_0_isError_ = out0_
        d_1_fileStream_ = out1_
        d_2_errorMsg_ = out2_
        if d_0_isError_:
            res = Wrappers.Result_Failure(d_2_errorMsg_)
        elif True:
            res = Wrappers.Result_Success(d_1_fileStream_)
        return res
        return res

    @staticmethod
    def ReadBytesFromFile(file):
        res: Wrappers.Result = Wrappers.Result.default(_dafny.Seq)()
        d_0_isError_: bool
        d_1_bytesRead_: _dafny.Seq
        d_2_errorMsg_: _dafny.Seq
        out0_: bool
        out1_: _dafny.Seq
        out2_: _dafny.Seq
        out0_, out1_, out2_ = DafnyLibraries.FileIO.Files.INTERNAL_ReadBytesFromFile(file)
        d_0_isError_ = out0_
        d_1_bytesRead_ = out1_
        d_2_errorMsg_ = out2_
        if d_0_isError_:
            res = Wrappers.Result_Failure(d_2_errorMsg_)
        elif True:
            res = Wrappers.Result_Success(d_1_bytesRead_)
        return res
        return res

    @staticmethod
    def WriteBytesToFile(file, bytes):
        res: Wrappers.Result = Wrappers.Result.default(_dafny.defaults.tuple())()
        d_0_isError_: bool
        d_1_errorMsg_: _dafny.Seq
        out0_: bool
        out1_: _dafny.Seq
        out0_, out1_ = DafnyLibraries.FileIO.Files.INTERNAL_WriteBytesToFile(file, bytes)
        d_0_isError_ = out0_
        d_1_errorMsg_ = out1_
        if d_0_isError_:
            res = Wrappers.Result_Failure(d_1_errorMsg_)
        elif True:
            res = Wrappers.Result_Success(())
        return res
        return res

    @staticmethod
    def IsLink(file):
        res: Wrappers.Result = Wrappers.Result.default(_dafny.defaults.bool)()
        d_0_isError_: bool
        d_1_isLink_: bool
        d_2_errorMsg_: _dafny.Seq
        out0_: bool
        out1_: bool
        out2_: _dafny.Seq
        out0_, out1_, out2_ = DafnyLibraries.FileIO.Files.INTERNAL_IsLink(file)
        d_0_isError_ = out0_
        d_1_isLink_ = out1_
        d_2_errorMsg_ = out2_
        if d_0_isError_:
            res = Wrappers.Result_Failure(d_2_errorMsg_)
        elif True:
            res = Wrappers.Result_Success(d_1_isLink_)
        return res

    @staticmethod
    def JoinPaths(paths, separator):
        res: Wrappers.Result = Wrappers.Result.default(_dafny.Seq)()
        d_0_isError_: bool
        d_1_fullPath_: _dafny.Seq
        d_2_errorMsg_: _dafny.Seq
        out0_: bool
        out1_: _dafny.Seq
        out2_: _dafny.Seq
        out0_, out1_, out2_ = DafnyLibraries.FileIO.Files.INTERNAL_JoinPaths(paths, separator)
        d_0_isError_ = out0_
        d_1_fullPath_ = out1_
        d_2_errorMsg_ = out2_
        if d_0_isError_:
            res = Wrappers.Result_Failure(d_2_errorMsg_)
        elif True:
            res = Wrappers.Result_Success(d_1_fullPath_)
        return res
        return res


class Error:
    @_dafny.classproperty
    def AllSingletonConstructors(cls):
        return [Error_Noent(), Error_Exist()]
    @classmethod
    def default(cls, ):
        return lambda: Error_Noent()
    def __ne__(self, __o: object) -> bool:
        return not self.__eq__(__o)
    @property
    def is_Noent(self) -> bool:
        return isinstance(self, Error_Noent)
    @property
    def is_Exist(self) -> bool:
        return isinstance(self, Error_Exist)

class Error_Noent(Error, NamedTuple('Noent', [])):
    def __dafnystr__(self) -> str:
        return f'FileIO.Error.Noent'
    def __eq__(self, __o: object) -> bool:
        return isinstance(__o, Error_Noent)
    def __hash__(self) -> int:
        return super().__hash__()

class Error_Exist(Error, NamedTuple('Exist', [])):
    def __dafnystr__(self) -> str:
        return f'FileIO.Error.Exist'
    def __eq__(self, __o: object) -> bool:
        return isinstance(__o, Error_Exist)
    def __hash__(self) -> int:
        return super().__hash__()


class Ok:
    @classmethod
    def default(cls, default_T):
        return lambda: default_T()
    def __ne__(self, __o: object) -> bool:
        return not self.__eq__(__o)
    @property
    def is_Ok(self) -> bool:
        return isinstance(self, Ok_Ok)

class Ok_Ok(Ok, NamedTuple('Ok', [('v', Any)])):
    def __dafnystr__(self) -> str:
        return f'FileIO.Ok.Ok({_dafny.string_of(self.v)})'
    def __eq__(self, __o: object) -> bool:
        return isinstance(__o, Ok_Ok) and self.v == __o.v
    def __hash__(self) -> int:
        return super().__hash__()

