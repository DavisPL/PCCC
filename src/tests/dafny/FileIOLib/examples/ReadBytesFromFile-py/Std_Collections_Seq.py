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

# Module: Std_Collections_Seq

class default__:
    def  __init__(self):
        pass

    @staticmethod
    def First(xs):
        return (xs)[0]

    @staticmethod
    def DropFirst(xs):
        return _dafny.SeqWithoutIsStrInference((xs)[1::])

    @staticmethod
    def Last(xs):
        return (xs)[(len(xs)) - (1)]

    @staticmethod
    def DropLast(xs):
        return _dafny.SeqWithoutIsStrInference((xs)[:(len(xs)) - (1):])

    @staticmethod
    def ToArray(xs):
        a: _dafny.Array = _dafny.Array(None, 0)
        def lambda3_(d_78_xs_):
            def lambda4_(d_79_i_):
                return (d_78_xs_)[d_79_i_]

            return lambda4_

        init2_ = lambda3_(xs)
        nw2_ = _dafny.Array(None, len(xs))
        for i0_2_ in range(nw2_.length(0)):
            nw2_[i0_2_] = init2_(i0_2_)
        a = nw2_
        return a

    @staticmethod
    def ToSet(xs):
        def iife0_():
            coll0_ = _dafny.Set()
            compr_0_: TypeVar('T__')
            for compr_0_ in (xs).Elements:
                d_80_x_: TypeVar('T__') = compr_0_
                if (d_80_x_) in (xs):
                    coll0_ = coll0_.union(_dafny.Set([d_80_x_]))
            return _dafny.Set(coll0_)
        return iife0_()
        

    @staticmethod
    def IndexOf(xs, v):
        d_81___accumulator_ = 0
        while True:
            with _dafny.label():
                if ((xs)[0]) == (v):
                    return (0) + (d_81___accumulator_)
                elif True:
                    d_81___accumulator_ = (d_81___accumulator_) + (1)
                    in0_ = _dafny.SeqWithoutIsStrInference((xs)[1::])
                    in1_ = v
                    xs = in0_
                    v = in1_
                    raise _dafny.TailCall()
                break

    @staticmethod
    def IndexOfOption(xs, v):
        def lambda5_(d_82_v_):
            def lambda6_(d_83_x_):
                return (d_83_x_) == (d_82_v_)

            return lambda6_

        return default__.IndexByOption(xs, lambda5_(v))

    @staticmethod
    def IndexByOption(xs, p):
        if (len(xs)) == (0):
            return Std_Wrappers.Option_None()
        elif p((xs)[0]):
            return Std_Wrappers.Option_Some(0)
        elif True:
            d_84_o_k_ = default__.IndexByOption(_dafny.SeqWithoutIsStrInference((xs)[1::]), p)
            if (d_84_o_k_).is_Some:
                return Std_Wrappers.Option_Some(((d_84_o_k_).value) + (1))
            elif True:
                return Std_Wrappers.Option_None()

    @staticmethod
    def LastIndexOf(xs, v):
        while True:
            with _dafny.label():
                if ((xs)[(len(xs)) - (1)]) == (v):
                    return (len(xs)) - (1)
                elif True:
                    in2_ = _dafny.SeqWithoutIsStrInference((xs)[:(len(xs)) - (1):])
                    in3_ = v
                    xs = in2_
                    v = in3_
                    raise _dafny.TailCall()
                break

    @staticmethod
    def LastIndexOfOption(xs, v):
        def lambda7_(d_85_v_):
            def lambda8_(d_86_x_):
                return (d_86_x_) == (d_85_v_)

            return lambda8_

        return default__.LastIndexByOption(xs, lambda7_(v))

    @staticmethod
    def LastIndexByOption(xs, p):
        while True:
            with _dafny.label():
                if (len(xs)) == (0):
                    return Std_Wrappers.Option_None()
                elif p((xs)[(len(xs)) - (1)]):
                    return Std_Wrappers.Option_Some((len(xs)) - (1))
                elif True:
                    in4_ = _dafny.SeqWithoutIsStrInference((xs)[:(len(xs)) - (1):])
                    in5_ = p
                    xs = in4_
                    p = in5_
                    raise _dafny.TailCall()
                break

    @staticmethod
    def Remove(xs, pos):
        return (_dafny.SeqWithoutIsStrInference((xs)[:pos:])) + (_dafny.SeqWithoutIsStrInference((xs)[(pos) + (1)::]))

    @staticmethod
    def RemoveValue(xs, v):
        if (v) not in (xs):
            return xs
        elif True:
            d_87_i_ = default__.IndexOf(xs, v)
            return (_dafny.SeqWithoutIsStrInference((xs)[:d_87_i_:])) + (_dafny.SeqWithoutIsStrInference((xs)[(d_87_i_) + (1)::]))

    @staticmethod
    def Insert(xs, a, pos):
        return ((_dafny.SeqWithoutIsStrInference((xs)[:pos:])) + (_dafny.SeqWithoutIsStrInference([a]))) + (_dafny.SeqWithoutIsStrInference((xs)[pos::]))

    @staticmethod
    def Reverse(xs):
        d_88___accumulator_ = _dafny.SeqWithoutIsStrInference([])
        while True:
            with _dafny.label():
                if (xs) == (_dafny.SeqWithoutIsStrInference([])):
                    return (d_88___accumulator_) + (_dafny.SeqWithoutIsStrInference([]))
                elif True:
                    d_88___accumulator_ = (d_88___accumulator_) + (_dafny.SeqWithoutIsStrInference([(xs)[(len(xs)) - (1)]]))
                    in6_ = _dafny.SeqWithoutIsStrInference((xs)[0:(len(xs)) - (1):])
                    xs = in6_
                    raise _dafny.TailCall()
                break

    @staticmethod
    def Repeat(v, length):
        d_89___accumulator_ = _dafny.SeqWithoutIsStrInference([])
        while True:
            with _dafny.label():
                if (length) == (0):
                    return (d_89___accumulator_) + (_dafny.SeqWithoutIsStrInference([]))
                elif True:
                    d_89___accumulator_ = (d_89___accumulator_) + (_dafny.SeqWithoutIsStrInference([v]))
                    in7_ = v
                    in8_ = (length) - (1)
                    v = in7_
                    length = in8_
                    raise _dafny.TailCall()
                break

    @staticmethod
    def Unzip(xs):
        if (len(xs)) == (0):
            return (_dafny.SeqWithoutIsStrInference([]), _dafny.SeqWithoutIsStrInference([]))
        elif True:
            let_tmp_rhs0_ = default__.Unzip(default__.DropLast(xs))
            d_90_a_ = let_tmp_rhs0_[0]
            d_91_b_ = let_tmp_rhs0_[1]
            return ((d_90_a_) + (_dafny.SeqWithoutIsStrInference([(default__.Last(xs))[0]])), (d_91_b_) + (_dafny.SeqWithoutIsStrInference([(default__.Last(xs))[1]])))

    @staticmethod
    def Zip(xs, ys):
        d_92___accumulator_ = _dafny.SeqWithoutIsStrInference([])
        while True:
            with _dafny.label():
                if (len(xs)) == (0):
                    return (_dafny.SeqWithoutIsStrInference([])) + (d_92___accumulator_)
                elif True:
                    d_92___accumulator_ = (_dafny.SeqWithoutIsStrInference([(default__.Last(xs), default__.Last(ys))])) + (d_92___accumulator_)
                    in9_ = default__.DropLast(xs)
                    in10_ = default__.DropLast(ys)
                    xs = in9_
                    ys = in10_
                    raise _dafny.TailCall()
                break

    @staticmethod
    def Max(xs):
        if (len(xs)) == (1):
            return (xs)[0]
        elif True:
            return Std_Math.default__.Max((xs)[0], default__.Max(_dafny.SeqWithoutIsStrInference((xs)[1::])))

    @staticmethod
    def Min(xs):
        if (len(xs)) == (1):
            return (xs)[0]
        elif True:
            return Std_Math.default__.Min((xs)[0], default__.Min(_dafny.SeqWithoutIsStrInference((xs)[1::])))

    @staticmethod
    def Flatten(xs):
        d_93___accumulator_ = _dafny.SeqWithoutIsStrInference([])
        while True:
            with _dafny.label():
                if (len(xs)) == (0):
                    return (d_93___accumulator_) + (_dafny.SeqWithoutIsStrInference([]))
                elif True:
                    d_93___accumulator_ = (d_93___accumulator_) + ((xs)[0])
                    in11_ = _dafny.SeqWithoutIsStrInference((xs)[1::])
                    xs = in11_
                    raise _dafny.TailCall()
                break

    @staticmethod
    def FlattenReverse(xs):
        d_94___accumulator_ = _dafny.SeqWithoutIsStrInference([])
        while True:
            with _dafny.label():
                if (len(xs)) == (0):
                    return (_dafny.SeqWithoutIsStrInference([])) + (d_94___accumulator_)
                elif True:
                    d_94___accumulator_ = (default__.Last(xs)) + (d_94___accumulator_)
                    in12_ = default__.DropLast(xs)
                    xs = in12_
                    raise _dafny.TailCall()
                break

    @staticmethod
    def Join(seqs, separator):
        d_95___accumulator_ = _dafny.SeqWithoutIsStrInference([])
        while True:
            with _dafny.label():
                if (len(seqs)) == (0):
                    return (d_95___accumulator_) + (_dafny.SeqWithoutIsStrInference([]))
                elif (len(seqs)) == (1):
                    return (d_95___accumulator_) + ((seqs)[0])
                elif True:
                    d_95___accumulator_ = (d_95___accumulator_) + (((seqs)[0]) + (separator))
                    in13_ = _dafny.SeqWithoutIsStrInference((seqs)[1::])
                    in14_ = separator
                    seqs = in13_
                    separator = in14_
                    raise _dafny.TailCall()
                break

    @staticmethod
    def Split(s, delim):
        d_96___accumulator_ = _dafny.SeqWithoutIsStrInference([])
        while True:
            with _dafny.label():
                d_97_i_ = default__.IndexOfOption(s, delim)
                if (d_97_i_).is_Some:
                    d_96___accumulator_ = (d_96___accumulator_) + (_dafny.SeqWithoutIsStrInference([_dafny.SeqWithoutIsStrInference((s)[:(d_97_i_).value:])]))
                    in15_ = _dafny.SeqWithoutIsStrInference((s)[((d_97_i_).value) + (1)::])
                    in16_ = delim
                    s = in15_
                    delim = in16_
                    raise _dafny.TailCall()
                elif True:
                    return (d_96___accumulator_) + (_dafny.SeqWithoutIsStrInference([s]))
                break

    @staticmethod
    def SplitOnce(s, delim):
        d_98_i_ = default__.IndexOfOption(s, delim)
        return (_dafny.SeqWithoutIsStrInference((s)[:(d_98_i_).value:]), _dafny.SeqWithoutIsStrInference((s)[((d_98_i_).value) + (1)::]))

    @staticmethod
    def SplitOnceOption(s, delim):
        d_99_valueOrError0_ = default__.IndexOfOption(s, delim)
        if (d_99_valueOrError0_).IsFailure():
            return (d_99_valueOrError0_).PropagateFailure()
        elif True:
            d_100_i_ = (d_99_valueOrError0_).Extract()
            return Std_Wrappers.Option_Some((_dafny.SeqWithoutIsStrInference((s)[:d_100_i_:]), _dafny.SeqWithoutIsStrInference((s)[(d_100_i_) + (1)::])))

    @staticmethod
    def Map(f, xs):
        d_101___accumulator_ = _dafny.SeqWithoutIsStrInference([])
        while True:
            with _dafny.label():
                if (len(xs)) == (0):
                    return (d_101___accumulator_) + (_dafny.SeqWithoutIsStrInference([]))
                elif True:
                    d_101___accumulator_ = (d_101___accumulator_) + (_dafny.SeqWithoutIsStrInference([f((xs)[0])]))
                    in17_ = f
                    in18_ = _dafny.SeqWithoutIsStrInference((xs)[1::])
                    f = in17_
                    xs = in18_
                    raise _dafny.TailCall()
                break

    @staticmethod
    def MapWithResult(f, xs):
        if (len(xs)) == (0):
            return Std_Wrappers.Result_Success(_dafny.SeqWithoutIsStrInference([]))
        elif True:
            d_102_valueOrError0_ = f((xs)[0])
            if (d_102_valueOrError0_).IsFailure():
                return (d_102_valueOrError0_).PropagateFailure()
            elif True:
                d_103_head_ = (d_102_valueOrError0_).Extract()
                d_104_valueOrError1_ = default__.MapWithResult(f, _dafny.SeqWithoutIsStrInference((xs)[1::]))
                if (d_104_valueOrError1_).IsFailure():
                    return (d_104_valueOrError1_).PropagateFailure()
                elif True:
                    d_105_tail_ = (d_104_valueOrError1_).Extract()
                    return Std_Wrappers.Result_Success((_dafny.SeqWithoutIsStrInference([d_103_head_])) + (d_105_tail_))

    @staticmethod
    def Filter(f, xs):
        d_106___accumulator_ = _dafny.SeqWithoutIsStrInference([])
        while True:
            with _dafny.label():
                if (len(xs)) == (0):
                    return (d_106___accumulator_) + (_dafny.SeqWithoutIsStrInference([]))
                elif True:
                    d_106___accumulator_ = (d_106___accumulator_) + ((_dafny.SeqWithoutIsStrInference([(xs)[0]]) if f((xs)[0]) else _dafny.SeqWithoutIsStrInference([])))
                    in19_ = f
                    in20_ = _dafny.SeqWithoutIsStrInference((xs)[1::])
                    f = in19_
                    xs = in20_
                    raise _dafny.TailCall()
                break

    @staticmethod
    def FoldLeft(f, init, xs):
        while True:
            with _dafny.label():
                if (len(xs)) == (0):
                    return init
                elif True:
                    in21_ = f
                    in22_ = f(init, (xs)[0])
                    in23_ = _dafny.SeqWithoutIsStrInference((xs)[1::])
                    f = in21_
                    init = in22_
                    xs = in23_
                    raise _dafny.TailCall()
                break

    @staticmethod
    def FoldRight(f, xs, init):
        if (len(xs)) == (0):
            return init
        elif True:
            return f((xs)[0], default__.FoldRight(f, _dafny.SeqWithoutIsStrInference((xs)[1::]), init))

    @staticmethod
    def SetToSeq(s):
        xs: _dafny.Seq = _dafny.Seq({})
        xs = _dafny.SeqWithoutIsStrInference([])
        d_107_left_: _dafny.Set
        d_107_left_ = s
        while (d_107_left_) != (_dafny.Set({})):
            d_108_x_: TypeVar('T__')
            with _dafny.label("_ASSIGN_SUCH_THAT_d_0"):
                assign_such_that_0_: TypeVar('T__')
                for assign_such_that_0_ in (d_107_left_).Elements:
                    d_108_x_ = assign_such_that_0_
                    if (d_108_x_) in (d_107_left_):
                        raise _dafny.Break("_ASSIGN_SUCH_THAT_d_0")
                raise Exception("assign-such-that search produced no value (line 7247)")
                pass
            d_107_left_ = (d_107_left_) - (_dafny.Set({d_108_x_}))
            xs = (xs) + (_dafny.SeqWithoutIsStrInference([d_108_x_]))
        return xs

    @staticmethod
    def SetToSortedSeq(s, R):
        xs: _dafny.Seq = _dafny.Seq({})
        out5_: _dafny.Seq
        out5_ = default__.SetToSeq(s)
        xs = out5_
        xs = default__.MergeSortBy(R, xs)
        return xs

    @staticmethod
    def MergeSortBy(lessThanOrEq, a):
        if (len(a)) <= (1):
            return a
        elif True:
            d_109_splitIndex_ = _dafny.euclidian_division(len(a), 2)
            d_110_left_ = _dafny.SeqWithoutIsStrInference((a)[:d_109_splitIndex_:])
            d_111_right_ = _dafny.SeqWithoutIsStrInference((a)[d_109_splitIndex_::])
            d_112_leftSorted_ = default__.MergeSortBy(lessThanOrEq, d_110_left_)
            d_113_rightSorted_ = default__.MergeSortBy(lessThanOrEq, d_111_right_)
            return default__.MergeSortedWith(d_112_leftSorted_, d_113_rightSorted_, lessThanOrEq)

    @staticmethod
    def MergeSortedWith(left, right, lessThanOrEq):
        d_114___accumulator_ = _dafny.SeqWithoutIsStrInference([])
        while True:
            with _dafny.label():
                if (len(left)) == (0):
                    return (d_114___accumulator_) + (right)
                elif (len(right)) == (0):
                    return (d_114___accumulator_) + (left)
                elif lessThanOrEq((left)[0], (right)[0]):
                    d_114___accumulator_ = (d_114___accumulator_) + (_dafny.SeqWithoutIsStrInference([(left)[0]]))
                    in24_ = _dafny.SeqWithoutIsStrInference((left)[1::])
                    in25_ = right
                    in26_ = lessThanOrEq
                    left = in24_
                    right = in25_
                    lessThanOrEq = in26_
                    raise _dafny.TailCall()
                elif True:
                    d_114___accumulator_ = (d_114___accumulator_) + (_dafny.SeqWithoutIsStrInference([(right)[0]]))
                    in27_ = left
                    in28_ = _dafny.SeqWithoutIsStrInference((right)[1::])
                    in29_ = lessThanOrEq
                    left = in27_
                    right = in28_
                    lessThanOrEq = in29_
                    raise _dafny.TailCall()
                break

