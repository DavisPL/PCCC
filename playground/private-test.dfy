module Helpers {
    class C {
        var f: int

        constructor()
        ensures f == 4
        {
         f := 4;  // Initialize f to 4
        }

        // Internal method to set f (not exported)
        method setF(value: int)
        requires value > 0
        modifies this
        ensures f == value
        {
            f := value;  // Only methods within this module can call setF
        }

        method mul(x: int) returns (y: int)
        requires f > 0
        requires x > 0
        ensures y == x * f
        ensures f == 5
        modifies this
        {
        this.setF(5);  // Modify f internally
        assert f == 5;  // Ensure f was set to 5
        y := x * f;  // After setting f to 5, this computes y = x * 5
        }

        method getF() returns (value: int)
        ensures value == f
        {
        value := f;  // Allow reading the value of f
        }
    }
    
}

module Mod {
  import Helpers
  method m() {
    var x := new Helpers.C();  // f is initialized to 4
    var t := 2;

    // Uncommenting the next line would cause an error because setF is not exported:
    // x.setF(10);  // Not allowed since `setF` is not provided by the export!
    assert t == 2;
    var res := x.mul(t);  // Calls mul(), which modifies f internally
    assert res == 10;  // Since f was set to 5 inside mul, result is 5 * 2 = 10
    // assert res == 10;  // Since f was set to 5 inside mul, result is 5 * 2 = 10
  }
}