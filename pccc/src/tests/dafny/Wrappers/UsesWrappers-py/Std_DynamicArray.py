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

# Module: Std_DynamicArray


class DynamicArray:
    def  __init__(self):
        self.size: int = int(0)
        self.capacity: int = int(0)
        self.data: _dafny.Array = _dafny.Array(None, 0)
        pass

    def __dafnystr__(self) -> str:
        return "Std.DynamicArray.DynamicArray"
    def ctor__(self):
        (self).size = 0
        (self).capacity = 0
        nw3_ = _dafny.Array(None, 0)
        (self).data = nw3_

    def At(self, index):
        return (self.data)[index]

    def Put(self, index, element):
        arr0_ = self.data
        arr0_[(index)] = element

    def Ensure(self, reserved, defaultValue):
        d_128_newCapacity_: int
        d_128_newCapacity_ = self.capacity
        while (reserved) > ((d_128_newCapacity_) - (self.size)):
            d_128_newCapacity_ = (self).DefaultNewCapacity(d_128_newCapacity_)
        if (d_128_newCapacity_) > (self.capacity):
            (self).Realloc(defaultValue, d_128_newCapacity_)

    def PopFast(self):
        (self).size = (self.size) - (1)

    def PushFast(self, element):
        arr1_ = self.data
        index5_ = self.size
        arr1_[index5_] = element
        (self).size = (self.size) + (1)

    def Push(self, element):
        if (self.size) == (self.capacity):
            (self).ReallocDefault(element)
        (self).PushFast(element)

    def Realloc(self, defaultValue, newCapacity):
        d_129_oldData_: _dafny.Array
        d_130_oldCapacity_: int
        rhs2_ = self.data
        rhs3_ = self.capacity
        d_129_oldData_ = rhs2_
        d_130_oldCapacity_ = rhs3_
        def lambda9_(d_131_defaultValue_):
            def lambda10_(d_132___v0_):
                return d_131_defaultValue_

            return lambda10_

        init3_ = lambda9_(defaultValue)
        nw4_ = _dafny.Array(None, newCapacity)
        for i0_3_ in range(nw4_.length(0)):
            nw4_[i0_3_] = init3_(i0_3_)
        rhs4_ = nw4_
        rhs5_ = newCapacity
        lhs0_ = self
        lhs1_ = self
        lhs0_.data = rhs4_
        lhs1_.capacity = rhs5_
        (self).CopyFrom(d_129_oldData_, d_130_oldCapacity_)

    def DefaultNewCapacity(self, capacity):
        if (capacity) == (0):
            return 8
        elif True:
            return (2) * (capacity)

    def ReallocDefault(self, defaultValue):
        (self).Realloc(defaultValue, (self).DefaultNewCapacity(self.capacity))

    def CopyFrom(self, newData, count):
        guard_loop_0_: int
        for guard_loop_0_ in _dafny.IntegerRange(0, count):
            d_133_index_: int = guard_loop_0_
            if (True) and (((0) <= (d_133_index_)) and ((d_133_index_) < (count))):
                arr2_ = self.data
                arr2_[(d_133_index_)] = (newData)[d_133_index_]

