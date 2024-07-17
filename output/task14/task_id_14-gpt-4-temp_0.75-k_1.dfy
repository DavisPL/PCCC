method TriangularPrismVolume(base: int, height: int, length: int) returns (volume: int)
    requires base > 0 && height > 0 && length > 0
    ensures volume == (base * height * length) / 2
{
    volume := (base * height * length) / 2;
    assert (base > 0 && height > 0 && length > 0);
    assert (base > 0 && height > 0 && length > 0) ==> volume == (base * height * length) / 2;
}