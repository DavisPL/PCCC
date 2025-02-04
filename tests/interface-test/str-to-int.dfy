include "/Users/pari/pcc-llms/stdlib/utils/AsciiConverter.dfy"

method test () {
  var c: char := 'a'; // Initialize a character
  var asciiValue1 := ASCIIConverter.CharToAscii(c); // Convert character to ASCII
  assert asciiValue1 == 97; // Assert the ASCII value of 'a' is 97
  var asciiValue2 := ASCIIConverter.CharToAscii('A'); // Assert the ASCII value of 'A' is 65
  assert asciiValue2 == 65;
  var asciiValue3 := ASCIIConverter.CharToAscii('0'); // Assert the ASCII value of '0' is 48
    assert asciiValue3 == 48;
    var strToBytes1 := ASCIIConverter.strToBytes("a"); // Convert string to bytes
    assert strToBytes1 == [97]; // Assert the ASCII values of 'a', 'b', 'c' are 97, 98, 99
    var strToBytes2 := ASCIIConverter.strToBytes("abc"); // Convert string to bytes
    assert strToBytes2 == [97, 98, 99]; // Assert the ASCII values of 'a', 'b', 'c' are 97, 98, 99
    var strToBytes3 := ASCIIConverter.strToBytes("A0z"); // Convert string to bytes
    assert strToBytes3 == [65, 48, 122]; // Assert the ASCII values of 'A', '0', 'z' are 65, 48, 122
    assert strToBytes3 != [65, 48, 123]; // Assert the ASCII values of 'A', '0', 'z' are 65, 48, 122
    assert strToBytes3 != [62, 48, 122]; // Assert the ASCII values of 'A', '0', 'z' are 65, 48, 122
    assert strToBytes3 != [65, 46, 122]; // Assert the ASCII values of 'A', '0', 'z' are 65, 48, 122
}