import sys
from typing import Callable, Any, TypeVar, NamedTuple
from math import floor
from itertools import count

import module_ as module_
import _dafny as _dafny
import System_ as System_
import Wrappers as Wrappers

# Module: Utils

class default__:
    def  __init__(self):
        pass

    @staticmethod
    def alpha__numeric(c):
        return ((((c) >= ('A')) and ((c) <= ('Z'))) or (((c) >= ('a')) and ((c) <= ('z')))) or (((c) >= ('0')) and ((c) <= ('9')))

    @staticmethod
    def is__alpha__numeric(s):
        def lambda0_(forall_var_0_):
            d_0_c_: str = forall_var_0_
            return not ((d_0_c_) in (s)) or (default__.alpha__numeric(d_0_c_))

        return _dafny.quantifier((s).UniqueElements, True, lambda0_)

    @staticmethod
    def is__drive__letter(c):
        return ((('a') <= (c)) and ((c) <= ('z'))) or ((('A') <= (c)) and ((c) <= ('Z')))

    @staticmethod
    def is__valid__char(c):
        return (default__.alpha__numeric(c)) or ((c) in (default__.validPathCharacters))

    @staticmethod
    def is__file__valid__char(c):
        return (default__.alpha__numeric(c)) or ((c) in (default__.validFileCharacters))

    @staticmethod
    def is__valid__file__name(filename):
        def lambda0_(forall_var_0_):
            d_0_i_: int = forall_var_0_
            return not (((0) <= (d_0_i_)) and ((d_0_i_) < (len(filename)))) or (default__.is__file__valid__char((filename)[d_0_i_]))

        return _dafny.quantifier(_dafny.IntegerRange(0, len(filename)), True, lambda0_)

    @staticmethod
    def is__valid__path__char(c):
        return (default__.alpha__numeric(c)) or ((c) in (default__.validPathCharacters))

    @staticmethod
    def is__valid__path__name(path):
        def lambda0_(forall_var_0_):
            d_0_i_: int = forall_var_0_
            return not (((0) <= (d_0_i_)) and ((d_0_i_) < (len(path)))) or (default__.is__valid__path__char((path)[d_0_i_]))

        return _dafny.quantifier(_dafny.IntegerRange(0, len(path)), True, lambda0_)

    @staticmethod
    def has__valid__file__length(f):
        return ((0) < (len(f))) and ((len(f)) < (default__.fileMaxLength))

    @staticmethod
    def is__valid__str__length(content):
        return ((-2147483648) <= (len(default__.string__to__bytes(content)))) and ((len(default__.string__to__bytes(content))) < (2147483648))

    @staticmethod
    def has__valid__content__length(content):
        return ((-2147483648) <= ((content).length(0))) and (((content).length(0)) < (2147483648))

    @staticmethod
    def is__valid__dir__char(c):
        return (default__.alpha__numeric(c)) or ((c) in (default__.validPathCharacters))

    @staticmethod
    def is__valid__dir(p):
        def lambda0_(forall_var_0_):
            d_0_i_: int = forall_var_0_
            return not (((0) <= (d_0_i_)) and ((d_0_i_) < (len(p)))) or (default__.is__valid__char((p)[d_0_i_]))

        return _dafny.quantifier(_dafny.IntegerRange(0, len(p)), True, lambda0_)

    @staticmethod
    def has__valid__path__length(p):
        return ((0) <= (len(p))) and ((len(p)) < (default__.pathMaxLength))

    @staticmethod
    def non__empty__path(f):
        return ((f) != (_dafny.Seq(""))) and ((len(f)) > (0))

    @staticmethod
    def validate__file__type(f):
        d_0_extension_ = default__.get__file__extension(f)
        if ((d_0_extension_) in (default__.allowedExtensionsForRead)) and ((d_0_extension_) not in (default__.invalidFileTypes)):
            return True
        elif True:
            return False

    @staticmethod
    def no__leading__trailing__space(filename):
        return (((filename)[0]) != (' ')) and (((filename)[(len(filename)) - (1)]) != (' '))

    @staticmethod
    def no__period__at__start(filename):
        return ((filename)[0]) != ('.')

    @staticmethod
    def string__slice(s):
        d_0___accumulator_ = _dafny.Seq([])
        while True:
            with _dafny.label():
                if (len(s)) == (0):
                    return (d_0___accumulator_) + (_dafny.Seq(""))
                elif True:
                    d_0___accumulator_ = (d_0___accumulator_) + (_dafny.Seq([(s)[(len(s)) - (1)]]))
                    in0_ = _dafny.Seq((s)[:(len(s)) - (1):])
                    s = in0_
                    raise _dafny.TailCall()
                break

    @staticmethod
    def concat(s1, s2):
        return (s1) + (s2)

    @staticmethod
    def joint__path__length(p, f):
        return ((((0) < (default__.get__path__length(PathOrFile_File(f)))) and ((default__.get__path__length(PathOrFile_File(f))) <= (default__.fileMaxLength))) and (((0) < (default__.get__path__length(PathOrFile_Path(p)))) and ((default__.get__path__length(PathOrFile_Path(p))) <= (default__.pathMaxLength)))) and (((default__.get__path__length(PathOrFile_Path(p))) + (default__.get__path__length(PathOrFile_File(f)))) <= (default__.pathMaxLength))

    @staticmethod
    def append__file__to__path(p, f):
        if (len(p)) == (0):
            return f
        elif ((p)[(len(p)) - (1)]) == ('/'):
            return default__.concat(p, f)
        elif True:
            return default__.concat(default__.concat(p, _dafny.Seq("/")), f)

    @staticmethod
    def get__path__length(pof):
        source0_ = pof
        if True:
            if source0_.is_Path:
                d_0_p_ = source0_.p
                return len(d_0_p_)
        if True:
            d_1_f_ = source0_.f
            return len(d_1_f_)

    @staticmethod
    def has__dangerous__pattern(p):
        return (((default__.contains__consecutive__periods(p)) or (not(default__.has__absolute__path(p)))) or (default__.contains__encoded__periods(p))) or (default__.contains__dangerous__pattern(p))

    @staticmethod
    def has__absolute__path(p):
        return ((len(p)) > (0)) and (((((p)[0]) == ('/')) or (((len(p)) > (1)) and (((p)[1]) == (':')))) or (((len(p)) > (2)) and (default__.is__valid__char((p)[2]))))

    @staticmethod
    def is__unix__absolute__path(p):
        return ((len(p)) > (0)) and (((p)[0]) == ('/'))

    @staticmethod
    def is__windows__absolute__path(p):
        d_0_isDrivePathWithSlash_ = ((((len(p)) >= (3)) and (default__.is__drive__letter((p)[0]))) and (((p)[1]) == (':'))) and ((((p)[2]) == ('\\')) or (((p)[2]) == ('/')))
        d_1_isDrivePath_ = (((len(p)) == (2)) and (default__.is__drive__letter((p)[0]))) and (((p)[1]) == (':'))
        d_2_isUNCPath_ = (((len(p)) >= (2)) and (((p)[0]) == ('\\'))) and (((p)[1]) == ('\\'))
        return ((d_0_isDrivePathWithSlash_) or (d_1_isDrivePath_)) or (d_2_isUNCPath_)

    @staticmethod
    def is__absolute__path(p):
        return (default__.is__unix__absolute__path(p)) or (default__.is__windows__absolute__path(p))

    @staticmethod
    def is__valid__file__extension(filename):
        d_0_lastDotIndex_ = default__.find__last__index__c(filename, '.')
        def lambda0_(forall_var_0_):
            d_1_i_: int = forall_var_0_
            return not (((d_0_lastDotIndex_) < (d_1_i_)) and ((d_1_i_) < (len(filename)))) or ((((filename)[d_1_i_]) != ('/')) and (((filename)[d_1_i_]) != ('\\')))

        return (((d_0_lastDotIndex_) >= (0)) and ((d_0_lastDotIndex_) < ((len(filename)) - (1)))) and (_dafny.quantifier(_dafny.IntegerRange((d_0_lastDotIndex_) + (1), len(filename)), True, lambda0_))

    @staticmethod
    def find__last__index__c(s, c):
        return default__.LastIndexOfLemma(s, c, (len(s)) - (1))

    @staticmethod
    def LastIndexOfLemma(s, c, start):
        while True:
            with _dafny.label():
                if ((start) == (-1)) or ((len(s)) == (0)):
                    return -1
                elif ((s)[start]) == (c):
                    return start
                elif True:
                    in0_ = s
                    in1_ = c
                    in2_ = (start) - (1)
                    s = in0_
                    c = in1_
                    start = in2_
                    raise _dafny.TailCall()
                break

    @staticmethod
    def get__file__extension(filename):
        d_0_lastDotIndex_ = default__.find__last__index__c(filename, '.')
        if (d_0_lastDotIndex_) == (-1):
            return _dafny.Seq([])
        elif True:
            return _dafny.Seq((filename)[(d_0_lastDotIndex_) + (1)::])

    @staticmethod
    def ValidateFileType(t):
        result: bool = False
        d_0_res_: bool
        out0_: bool
        out0_ = default__.ContainsSequence(default__.sensitivePaths, t)
        d_0_res_ = out0_
        if not(d_0_res_):
            result = True
        elif True:
            result = False
        return result

    @staticmethod
    def ContainsC(s, c):
        result: bool = False
        result = False
        d_0_i_: int
        d_0_i_ = 0
        with _dafny.label("0"):
            while (d_0_i_) < (len(s)):
                with _dafny.c_label("0"):
                    if ((s)[d_0_i_]) == (c):
                        result = True
                        raise _dafny.Break("0")
                    d_0_i_ = (d_0_i_) + (1)
                    pass
            pass
        return result

    @staticmethod
    def is__prefix(p1, p2):
        return ((len(p1)) <= (len(p2))) and ((p1) == (_dafny.Seq((p2)[:len(p1):])))

    @staticmethod
    def ContainsSequence(list, sub):
        result: bool = False
        result = False
        with _dafny.label("1"):
            hi0_ = len(list)
            for d_0_i_ in range(0, hi0_):
                with _dafny.c_label("1"):
                    if (sub) == ((list)[d_0_i_]):
                        result = True
                        raise _dafny.Break("1")
                    pass
            pass
        return result

    @staticmethod
    def is__lower__case(c):
        return ((97) <= (ord(c))) and ((ord(c)) <= (122))

    @staticmethod
    def is__lower__upper__pair(c, C):
        return (ord(c)) == ((ord(C)) + (32))

    @staticmethod
    def shift__minus32(c):
        return chr(_dafny.euclidian_modulus((ord(c)) - (32), 128))

    @staticmethod
    def ToUppercase(s):
        v: _dafny.Seq = _dafny.Seq("")
        d_0_s_k_: _dafny.Seq
        d_0_s_k_ = _dafny.Seq([])
        hi0_ = len(s)
        for d_1_i_ in range(0, hi0_):
            if default__.is__lower__case((s)[d_1_i_]):
                d_0_s_k_ = (d_0_s_k_) + (_dafny.Seq([default__.shift__minus32((s)[d_1_i_])]))
            elif True:
                d_0_s_k_ = (d_0_s_k_) + (_dafny.Seq([(s)[d_1_i_]]))
        v = d_0_s_k_
        return v
        return v

    @staticmethod
    def ArrayFromSeq(s):
        a: _dafny.Array = _dafny.Array(None, 0)
        def lambda0_(d_0_s_):
            def lambda1_(d_1_i_):
                return (d_0_s_)[d_1_i_]

            return lambda1_

        init0_ = lambda0_(s)
        nw0_ = _dafny.Array(None, len(s))
        for i0_0_ in range(nw0_.length(0)):
            nw0_[i0_0_] = init0_(i0_0_)
        a = nw0_
        return a

    @staticmethod
    def digit__to__char(n):
        return _dafny.plus_char('0', chr(n))

    @staticmethod
    def numbert__to__string(n):
        d_0___accumulator_ = _dafny.Seq([])
        while True:
            with _dafny.label():
                if (n) < (10):
                    return (_dafny.Seq([default__.digit__to__char(n)])) + (d_0___accumulator_)
                elif True:
                    d_0___accumulator_ = (_dafny.Seq([default__.digit__to__char(_dafny.euclidian_modulus(n, 10))])) + (d_0___accumulator_)
                    in0_ = _dafny.euclidian_division(n, 10)
                    n = in0_
                    raise _dafny.TailCall()
                break

    @staticmethod
    def Computedigit__to__char(n):
        result: str = 'D'
        result = _dafny.plus_char('0', chr(n))
        return result
        return result

    @staticmethod
    def ConvertNumberToString(n):
        r: _dafny.Seq = _dafny.Seq("")
        if (n) < (10):
            d_0_digit__to__char_: str
            out0_: str
            out0_ = default__.Computedigit__to__char(n)
            d_0_digit__to__char_ = out0_
            r = _dafny.Seq([d_0_digit__to__char_])
        elif True:
            d_1_numToChar_: _dafny.Seq
            out1_: _dafny.Seq
            out1_ = default__.ConvertNumberToString(_dafny.euclidian_division(n, 10))
            d_1_numToChar_ = out1_
            d_2_digit__to__char_: str
            out2_: str
            out2_ = default__.Computedigit__to__char(_dafny.euclidian_modulus(n, 10))
            d_2_digit__to__char_ = out2_
            r = (d_1_numToChar_) + (_dafny.Seq([d_2_digit__to__char_]))
        return r

    @staticmethod
    def char__to__int(c):
        return ord(c)

    @staticmethod
    def char__to__byte(c):
        d_0_i_ = default__.char__to__int(c)
        if ((0) <= (d_0_i_)) and ((d_0_i_) < (256)):
            return d_0_i_
        elif True:
            return 0

    @staticmethod
    def string__to__bytes(s):
        d_0___accumulator_ = _dafny.Seq([])
        while True:
            with _dafny.label():
                if (len(s)) == (0):
                    return (d_0___accumulator_) + (_dafny.Seq([]))
                elif True:
                    d_0___accumulator_ = (d_0___accumulator_) + (_dafny.Seq([default__.char__to__byte((s)[0])]))
                    in0_ = _dafny.Seq((s)[1::])
                    s = in0_
                    raise _dafny.TailCall()
                break

    @staticmethod
    def StringToSeqInt(s):
        bytesSeq: _dafny.Seq = _dafny.Seq({})
        bytesSeq = _dafny.Seq([])
        d_0_i_: int
        d_0_i_ = 0
        while (d_0_i_) < (len(s)):
            bytesSeq = (bytesSeq) + (_dafny.Seq([default__.char__to__int((s)[d_0_i_])]))
            d_0_i_ = (d_0_i_) + (1)
        return bytesSeq

    @staticmethod
    def list__contains__string(list, sub):
        while True:
            with _dafny.label():
                if (len(list)) == (0):
                    return False
                elif (sub) == ((list)[0]):
                    return True
                elif True:
                    in0_ = _dafny.Seq((list)[1::])
                    in1_ = sub
                    list = in0_
                    sub = in1_
                    raise _dafny.TailCall()
                break

    @staticmethod
    def ContainsChar(s, c):
        def lambda0_(exists_var_0_):
            d_0_i_: int = exists_var_0_
            return (((0) <= (d_0_i_)) and ((d_0_i_) < (len(s)))) and (((s)[d_0_i_]) == (c))

        return _dafny.quantifier(_dafny.IntegerRange(0, len(s)), False, lambda0_)

    @staticmethod
    def ContainsCharMethod(s, c):
        result: bool = False
        result = False
        d_0_i_: int
        d_0_i_ = 0
        while (d_0_i_) < (len(s)):
            if ((s)[d_0_i_]) == (c):
                result = True
                return result
            d_0_i_ = (d_0_i_) + (1)
        return result

    @staticmethod
    def non__empty__string(s):
        return ((len(s)) > (0)) and ((s) != (_dafny.Seq("")))

    @staticmethod
    def HasNoReservedNames(path):
        isValid: bool = False
        d_0_reservedNames_: _dafny.Seq
        d_0_reservedNames_ = _dafny.Seq([_dafny.Seq("CON"), _dafny.Seq("PRN"), _dafny.Seq("AUX"), _dafny.Seq("NUL"), _dafny.Seq("COM1"), _dafny.Seq("COM2"), _dafny.Seq("COM3"), _dafny.Seq("COM4"), _dafny.Seq("LPT1"), _dafny.Seq("LPT2"), _dafny.Seq("LPT3"), _dafny.Seq("LPT4")])
        d_1_upperPath_: _dafny.Seq
        out0_: _dafny.Seq
        out0_ = default__.ToUppercase(path)
        d_1_upperPath_ = out0_
        hi0_ = len(d_0_reservedNames_)
        for d_2_i_ in range(0, hi0_):
            d_3_startsWithReserved_: bool
            out1_: bool
            out1_ = default__.StartsWith(d_1_upperPath_, ((d_0_reservedNames_)[d_2_i_]) + (_dafny.Seq(".")))
            d_3_startsWithReserved_ = out1_
            if ((d_1_upperPath_) == ((d_0_reservedNames_)[d_2_i_])) or (d_3_startsWithReserved_):
                isValid = False
                return isValid
        isValid = True
        return isValid
        return isValid

    @staticmethod
    def StartsWith(s, prefix):
        result: bool = False
        if (len(s)) < (len(prefix)):
            result = False
        elif True:
            result = (_dafny.Seq((s)[:len(prefix):])) == (prefix)
        return result

    @staticmethod
    def contains__consecutive__periods(s):
        while True:
            with _dafny.label():
                if (len(s)) < (2):
                    return False
                elif (((s)[0]) == ('.')) and (((s)[1]) == ('.')):
                    return True
                elif True:
                    in0_ = _dafny.Seq((s)[1::])
                    s = in0_
                    raise _dafny.TailCall()
                break

    @staticmethod
    def contains__encoded__periods(s):
        while True:
            with _dafny.label():
                if (len(s)) < (4):
                    return False
                elif (((((s)[0]) == ('%')) and (((s)[1]) == ('2'))) and (((s)[2]) == ('e'))) and (((s)[3]) == ('e')):
                    return True
                elif True:
                    in0_ = _dafny.Seq((s)[1::])
                    s = in0_
                    raise _dafny.TailCall()
                break

    @staticmethod
    def contains__parent__dir__traversal(s):
        while True:
            with _dafny.label():
                if (len(s)) < (2):
                    return False
                elif (((s)[0]) == ('.')) and (((s)[1]) == ('.')):
                    return True
                elif True:
                    in0_ = _dafny.Seq((s)[1::])
                    s = in0_
                    raise _dafny.TailCall()
                break

    @staticmethod
    def contains__home__dir__reference(s):
        while True:
            with _dafny.label():
                if (len(s)) < (1):
                    return False
                elif ((s)[0]) == ('~'):
                    return True
                elif True:
                    in0_ = _dafny.Seq((s)[1::])
                    s = in0_
                    raise _dafny.TailCall()
                break

    @staticmethod
    def contains__drive__letter(s):
        while True:
            with _dafny.label():
                if (len(s)) < (1):
                    return False
                elif ((s)[0]) == (':'):
                    return True
                elif True:
                    in0_ = _dafny.Seq((s)[1::])
                    s = in0_
                    raise _dafny.TailCall()
                break

    @staticmethod
    def contains__dangerous__pattern(s):
        return ((default__.contains__parent__dir__traversal(s)) or (default__.contains__home__dir__reference(s))) or (default__.contains__drive__letter(s))

    @staticmethod
    def is__canonical__path(p):
        return True

    @_dafny.classproperty
    def fileMaxSize(instance):
        return 2040109465
    @_dafny.classproperty
    def validPathCharacters(instance):
        return _dafny.Set({'~', '-', '_', '.', '(', ')', ' ', '%', '/'})
    @_dafny.classproperty
    def validFileCharacters(instance):
        return _dafny.Set({'-', '_', '.', '(', ')', ' ', '%'})
    @_dafny.classproperty
    def fileMaxLength(instance):
        return 50
    @_dafny.classproperty
    def pathMaxLength(instance):
        return 1024
    @_dafny.classproperty
    def allowedExtensionsForRead(instance):
        return _dafny.Seq([_dafny.Seq("txt"), _dafny.Seq("pdf"), _dafny.Seq("docx")])
    @_dafny.classproperty
    def invalidFileTypes(instance):
        return _dafny.Seq([_dafny.Seq("php"), _dafny.Seq("CON"), _dafny.Seq("PRN"), _dafny.Seq("AUX"), _dafny.Seq("NUL"), _dafny.Seq("COM1"), _dafny.Seq("COM2"), _dafny.Seq("COM3"), _dafny.Seq("COM4"), _dafny.Seq("LPT1"), _dafny.Seq("LPT2"), _dafny.Seq("LPT3"), _dafny.Seq("LPT4"), _dafny.Seq("LPT5"), _dafny.Seq("LPT6"), _dafny.Seq("LPT7"), _dafny.Seq("LPT8"), _dafny.Seq("LPT9")])
    @_dafny.classproperty
    def sensitivePaths(instance):
        return _dafny.Seq([_dafny.Seq("/id_rsa"), _dafny.Seq("/usr"), _dafny.Seq("/System"), _dafny.Seq("/bin"), _dafny.Seq("/sbin"), _dafny.Seq("/var"), _dafny.Seq("/usr/local"), _dafny.Seq("/documnets"), _dafny.Seq("/etc/passwd")])
    @_dafny.classproperty
    def fileMinLength(instance):
        return 4
    @_dafny.classproperty
    def currWDir(instance):
        return _dafny.Seq([_dafny.Seq("/Users/pari/pcc-llms/src/playground")])
    @_dafny.classproperty
    def allowedServices(instance):
        return _dafny.Map({_dafny.Seq("apache"): _dafny.Seq([_dafny.Seq("access.log"), _dafny.Seq("error.log")]), _dafny.Seq("mysql"): _dafny.Seq([_dafny.Seq("query.log"), _dafny.Seq("slow.log")]), _dafny.Seq("ssh"): _dafny.Seq([_dafny.Seq("auth.log")])})
    @_dafny.classproperty
    def allowedExtensionsForWrite(instance):
        return _dafny.Seq([_dafny.Seq("txt"), _dafny.Seq("docx")])

class byte:
    def  __init__(self):
        pass

    @staticmethod
    def default():
        return int(0)
    def _Is(source__):
        return True

class int32:
    def  __init__(self):
        pass

    @staticmethod
    def default():
        return int(0)
    def _Is(source__):
        return True

class nat32:
    def  __init__(self):
        pass

    @staticmethod
    def default():
        return int(0)
    def _Is(source__):
        d_0_i_: int = source__
        return ((0) <= (d_0_i_)) and ((d_0_i_) < (2147483648))

class maxPath:
    def  __init__(self):
        pass

    @staticmethod
    def default():
        return int(0)
    def _Is(source__):
        d_1_i_: int = source__
        return ((0) <= (d_1_i_)) and ((d_1_i_) < (256))

class nat64:
    def  __init__(self):
        pass

    @staticmethod
    def default():
        return int(0)
    def _Is(source__):
        return True

class PathOrFile:
    @classmethod
    def default(cls, ):
        return lambda: PathOrFile_Path(_dafny.Seq(""))
    def __ne__(self, __o: object) -> bool:
        return not self.__eq__(__o)
    @property
    def is_Path(self) -> bool:
        return isinstance(self, PathOrFile_Path)
    @property
    def is_File(self) -> bool:
        return isinstance(self, PathOrFile_File)

class PathOrFile_Path(PathOrFile, NamedTuple('Path', [('p', Any)])):
    def __dafnystr__(self) -> str:
        return f'Utils.PathOrFile.Path({_dafny.string_of(self.p)})'
    def __eq__(self, __o: object) -> bool:
        return isinstance(__o, PathOrFile_Path) and self.p == __o.p
    def __hash__(self) -> int:
        return super().__hash__()

class PathOrFile_File(PathOrFile, NamedTuple('File', [('f', Any)])):
    def __dafnystr__(self) -> str:
        return f'Utils.PathOrFile.File({_dafny.string_of(self.f)})'
    def __eq__(self, __o: object) -> bool:
        return isinstance(__o, PathOrFile_File) and self.f == __o.f
    def __hash__(self) -> int:
        return super().__hash__()


class Permission:
    @_dafny.classproperty
    def AllSingletonConstructors(cls):
        return [Permission_Read(), Permission_Write(), Permission_Execute()]
    @classmethod
    def default(cls, ):
        return lambda: Permission_Read()
    def __ne__(self, __o: object) -> bool:
        return not self.__eq__(__o)
    @property
    def is_Read(self) -> bool:
        return isinstance(self, Permission_Read)
    @property
    def is_Write(self) -> bool:
        return isinstance(self, Permission_Write)
    @property
    def is_Execute(self) -> bool:
        return isinstance(self, Permission_Execute)

class Permission_Read(Permission, NamedTuple('Read', [])):
    def __dafnystr__(self) -> str:
        return f'Utils.Permission.Read'
    def __eq__(self, __o: object) -> bool:
        return isinstance(__o, Permission_Read)
    def __hash__(self) -> int:
        return super().__hash__()

class Permission_Write(Permission, NamedTuple('Write', [])):
    def __dafnystr__(self) -> str:
        return f'Utils.Permission.Write'
    def __eq__(self, __o: object) -> bool:
        return isinstance(__o, Permission_Write)
    def __hash__(self) -> int:
        return super().__hash__()

class Permission_Execute(Permission, NamedTuple('Execute', [])):
    def __dafnystr__(self) -> str:
        return f'Utils.Permission.Execute'
    def __eq__(self, __o: object) -> bool:
        return isinstance(__o, Permission_Execute)
    def __hash__(self) -> int:
        return super().__hash__()

