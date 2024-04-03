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

# Module: Std_Collections_Map

class default__:
    def  __init__(self):
        pass

    @staticmethod
    def Get(m, x):
        if (x) in (m):
            return Std_Wrappers.Option_Some((m)[x])
        elif True:
            return Std_Wrappers.Option_None()

    @staticmethod
    def ToImap(m):
        def iife1_():
            coll1_ = _dafny.Map()
            compr_1_: TypeVar('X__')
            for compr_1_ in (m).keys.Elements:
                d_118_x_: TypeVar('X__') = compr_1_
                if (d_118_x_) in (m):
                    coll1_[d_118_x_] = (m)[d_118_x_]
            return _dafny.Map(coll1_)
        return iife1_()
        

    @staticmethod
    def RemoveKeys(m, xs):
        return (m) - (xs)

    @staticmethod
    def Remove(m, x):
        def iife2_():
            coll2_ = _dafny.Map()
            compr_2_: TypeVar('X__')
            for compr_2_ in (m).keys.Elements:
                d_120_x_k_: TypeVar('X__') = compr_2_
                if ((d_120_x_k_) in (m)) and ((d_120_x_k_) != (x)):
                    coll2_[d_120_x_k_] = (m)[d_120_x_k_]
            return _dafny.Map(coll2_)
        d_119_m_k_ = iife2_()

        return d_119_m_k_

    @staticmethod
    def Restrict(m, xs):
        def iife3_():
            coll3_ = _dafny.Map()
            compr_3_: TypeVar('X__')
            for compr_3_ in (xs).Elements:
                d_121_x_: TypeVar('X__') = compr_3_
                if ((d_121_x_) in (xs)) and ((d_121_x_) in (m)):
                    coll3_[d_121_x_] = (m)[d_121_x_]
            return _dafny.Map(coll3_)
        return iife3_()
        

    @staticmethod
    def Union(m, m_k):
        return (m) | (m_k)

