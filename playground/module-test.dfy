module A {
  export provides a
  const a := 10
  const b := 20
}

module B {
  import A
  method m() {
    // assert A.a == 10; // a and its value are known
    // assert A.b == 20; // b is not known through A`A
  }
}

module C {
  export reveals a
  const a := 10
  const b := 20
}

module D {
  import C
  method m() {
    assert C.a == 10; // a and its value are known
    // assert A.b == 20; // b is not known through A`A
  }
}

module E {
//   export reveals a, myClass provides myClass.x
export reveals a
  const a := 10
  const b := 20
//   class myClass {
//     ghost var x: int
//     constructor Init() {
//       x := 1000;
//     }
    method add(x: int) returns (y: int)
    ensures y == x + 1
    {
      y := x + 1;
    }
//   }
}

module F {
  import E
  method m() {
    // assert E.myClass.add(5) == 6; // x and its value are known
    // assert E.myClass.x == 1000; // x and its value are known
    assert E.a == 10; // a and its value are known
    // assert A.b == 20; // b is not known through A`A
  }
}

 module Helpers {
  // export reveals C provides C.getF, C.mul
    class C {
      constructor () { f := 1; }
      method mul(x: int) returns (y: int)
      // requires f > 0
      requires x > 0
      ensures y == x * 4 // f is a field of C
      modifies this 
      // ensures f == 4 
      {
        this.setF(4);
        assert f == 4;
        y := x * f;
      }
      var f: int

    method setF(value: int)
    modifies this
    requires value > 0
    ensures f == value
    {
      f := value;
    }

    method getF() returns (value: int)
    ensures value == f  
    {
  
      value := f;  // Allows read access but not modification
      assert value == f;
    }
    //   method pow(x: int) returns (y: int)
    //     ensures y == x * x
    //     {
    //         y := x * x;
    //     }
    }
  }

module Mod {
  export provides m
  import Helpers
  method m() {

    var x := new Helpers.C();
    var t := 2;
    x.setF(4);
    var currentF := x.getF();
    
    if (x.f > 0) {
      var res := x.mul(t);
       assert res == 8;
    }
    assert currentF == 4;
    // var power := x.pow(2);
    // assert power == 4;
  }
//   method addOne(x: int) returns (y: int)
//     ensures y == x + 1
//     {
//       y := x + 1;
//     }
}

module Test {
  import Mod
  method test() {
    Mod.m();
    // Mod.addOne(5);
  }
}

 module Helpers2 {
    export provides addOne
    function addOne(n: nat): nat {
      n + 1
    }
  }

module Mod2 {
  import Helpers2
  method m() {
    var x := 5;
    x := Helpers2.addOne(x); // x is now 6
  }
}

module TestMod {
    class C {
        ghost var x: int;
        constructor Init() {
            x := 0;
        }
        method m() {
            x := 1;
        }
    }
//   ghost var k: int;
//   if i, j :| 0 < i+j < 10 {
//     k := 0;
//   } else {
//     k := 1;
//   }
}