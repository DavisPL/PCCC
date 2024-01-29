method Main() {
  var n := 10; // replace with your desired number
  print Fibonacci(n);
}

function Fibonacci(n: nat): nat {
  if n <= 2 then 1
  else Fibonacci(n-1) + Fibonacci(n-2)
}