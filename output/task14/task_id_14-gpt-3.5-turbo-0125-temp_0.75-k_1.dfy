method TriangularPrismVolume(base: int, height: int, length: int) returns (volume: int)
    requires base > 0 && height > 0 && length > 0
    ensures volume == (base * height / 2) * length
{
    volume := (base * height / 2) * length;
}