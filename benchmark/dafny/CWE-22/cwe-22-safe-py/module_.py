import sys
from typing import Callable, Any, TypeVar, NamedTuple
from math import floor
from itertools import count

import module_ as module_
import _dafny as _dafny
import System_ as System_
import Wrappers as Wrappers
import Utils as Utils
import FileIO as FileIO

# Module: module_

class default__:
    def  __init__(self):
        pass

    @staticmethod
    def Main(args):
        if not((len(args)) > (0)):
            raise _dafny.HaltException("benchmark/dafny/CWE-22/cwe-22-safe.dfy(8,4): " + _dafny.string_of(_dafny.Seq("expectation violation")))
        if not((len(args)) == (3)):
            raise _dafny.HaltException("benchmark/dafny/CWE-22/cwe-22-safe.dfy(9,4): " + _dafny.string_of(((_dafny.Seq("usage: ")) + ((args)[0])) + (_dafny.Seq(" FILE_PATH EXPECTED_ERROR_PREFIX"))))
        d_0_filePath_: _dafny.Seq
        d_0_filePath_ = (args)[1]
        d_1_expectedErrorPrefix_: _dafny.Seq
        d_1_expectedErrorPrefix_ = (args)[2]
        d_2_baseDir_: _dafny.Seq
        d_2_baseDir_ = _dafny.Seq("/Users/pari/pcc-llms/benchmark/dafny/CWE-22/")
        d_3_joinRes_: Wrappers.Result
        out0_: Wrappers.Result
        out0_ = FileIO.default__.JoinPaths(_dafny.Seq([d_2_baseDir_, d_0_filePath_]), _dafny.Seq("/"))
        d_3_joinRes_ = out0_
        if not((d_3_joinRes_).is_Success):
            raise _dafny.HaltException("benchmark/dafny/CWE-22/cwe-22-safe.dfy(16,8): " + _dafny.string_of((_dafny.Seq("unexpected failure: ")) + ((d_3_joinRes_).error)))
        d_4_jointPath_: _dafny.Seq
        d_4_jointPath_ = _dafny.Seq([((d_3_joinRes_).value)[d_5_i_] for d_5_i_ in range(len((d_3_joinRes_).value))])
        d_6_expectedStr_: _dafny.Seq
        d_6_expectedStr_ = _dafny.Seq("Hello world\nGoodbye?\n")
        d_7_expectedBytes_: _dafny.Seq
        d_7_expectedBytes_ = _dafny.Seq([ord((d_6_expectedStr_)[d_8_i_]) for d_8_i_ in range(len(d_6_expectedStr_))])
        if ((Utils.default__.non__empty__path(d_4_jointPath_)) and (Utils.default__.has__absolute__path(d_4_jointPath_))) and (not(Utils.default__.has__dangerous__pattern(d_4_jointPath_))):
            d_9_res_: Wrappers.Result
            out1_: Wrappers.Result
            out1_ = FileIO.default__.Open(d_4_jointPath_)
            d_9_res_ = out1_
            if not((d_9_res_).is_Success):
                d_4_jointPath_ = _dafny.Seq("")
                return
            elif True:
                d_10_readRes_: Wrappers.Result
                out2_: Wrappers.Result
                out2_ = FileIO.default__.ReadBytesFromFile(d_4_jointPath_)
                d_10_readRes_ = out2_
                if not((d_10_readRes_).is_Success):
                    raise _dafny.HaltException("benchmark/dafny/CWE-22/cwe-22-safe.dfy(28,12): " + _dafny.string_of((_dafny.Seq("unexpected failure: ")) + ((d_10_readRes_).error)))
                if (d_10_readRes_).is_Failure:
                    d_11_readRes2_: Wrappers.Result
                    out3_: Wrappers.Result
                    out3_ = FileIO.default__.ReadBytesFromFile(_dafny.Seq(""))
                    d_11_readRes2_ = out3_
                    if not((d_11_readRes2_).is_Failure):
                        raise _dafny.HaltException("benchmark/dafny/CWE-22/cwe-22-safe.dfy(32,14): " + _dafny.string_of(_dafny.Seq("unexpected success")))
                    if not((d_1_expectedErrorPrefix_) <= ((d_11_readRes2_).error)):
                        raise _dafny.HaltException("benchmark/dafny/CWE-22/cwe-22-safe.dfy(33,14): " + _dafny.string_of((_dafny.Seq("unexpected error message: ")) + ((d_11_readRes2_).error)))
                elif True:
                    d_12_readBytes_: _dafny.Seq
                    d_12_readBytes_ = _dafny.Seq([((d_10_readRes_).value)[d_13_i_] for d_13_i_ in range(len((d_10_readRes_).value))])
                    if not((d_12_readBytes_) == (d_7_expectedBytes_)):
                        raise _dafny.HaltException("benchmark/dafny/CWE-22/cwe-22-safe.dfy(36,14): " + _dafny.string_of(_dafny.Seq("read unexpected byte sequence")))

