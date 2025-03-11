
include "../../std/utils/utils.dfy"
import utils = Utils
method TestCases() {
    var dotdot := utils.HasDotDot("..");
    assert utils.contains_consecutive_periods("..");
    assert dotdot == true;
    dotdot := utils.HasDotDot("a..b");
    assert utils.contains_consecutive_periods("a/..b");
    assert utils.contains_consecutive_periods("a../b");
    assert utils.contains_consecutive_periods("a/../b");
    assert utils.contains_consecutive_periods("/a/../b");
    assert utils.contains_consecutive_periods("/a/../b/..");
    assert utils.contains_consecutive_periods("..b");
    assert utils.contains_consecutive_periods("a...");
    assert !utils.contains_consecutive_periods("a.b");
    assert !utils.contains_consecutive_periods(".a.b");
    assert !utils.contains_consecutive_periods(".a.b.txt");
   }
