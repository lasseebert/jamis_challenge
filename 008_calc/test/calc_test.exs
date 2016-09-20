defmodule CalcTest do
  use ExUnit.Case

  test "simple plus statement" do
    assert Calc.eval("1 + 2") == 3
  end

  test "simple multiplication" do
    assert Calc.eval("2 * 8") == 16
  end

  test "multiplication precedence" do
    assert Calc.eval("4 + 2 * 8") == 20
  end

  test "parenthesis" do
    assert Calc.eval("(4 + 2) * 8") == 48
  end

  test "all simple operations" do
    assert Calc.eval("((((5)+2)*2)-5)/3") == 3
  end

  test "unary minus" do
    assert Calc.eval("6 * -3") == -18
  end

  test "unary minus for expression" do
    assert Calc.eval("-(5 * 2) - 2") == -12
  end

  test "exponential" do
    assert Calc.eval("2 ^ 3") == 8
  end

  test "exponential precedence" do
    assert Calc.eval("4 * 2 ^ 3") == 32
  end

  test "variable assignment" do
    assert Calc.eval("(a = 1) + a") == 2
  end

  test "multiple expressions" do
    assert Calc.eval("x = 5; y = 3; (x + 1) * y") == 18
  end

  test "ternary true" do
    assert Calc.eval("a = 42; a ? 3 : 7") == 3
  end

  test "ternary false" do
    assert Calc.eval("a = 0; a ? 3 : 7") == 7
  end

  test "ternary does not evaluate false part" do
    assert Calc.eval("1 ? a = 1 : a = 2; a") == 1
  end

  test "ternary precedense" do
    assert Calc.eval("1 - 1 ? 1 : 2") == 2
  end

  test "nested ternary operator" do
    assert Calc.eval("1 ? 2 ? 3 : 4 : 5") == 3
  end

  test "cosine" do
    assert Calc.eval("cos(0)") == 1
  end

  test "sine" do
    assert Calc.eval("sin(0)") == 0
  end

  test "custom function with one parameter" do
    assert Calc.eval("square = fun(x) { x * x }; square(6)") == 36
  end

  test "custom function has local scope" do
    assert Calc.eval("a = 1; myfun = fun() { a = 2 }; myfun(); a") == 1
  end

  test "multiple expressions in function" do
    assert Calc.eval("myfun = fun(x) { y = 1; x + y }; myfun(4)") == 5
  end

  test "function with no parameters" do
    assert Calc.eval("myfun = fun() { 42 }; myfun()") == 42
  end

  test "function with many parameters" do
    assert Calc.eval("myfun = fun(x, y, z) { x + y + z }; myfun(1, 2, 3)") == 6
  end

  test "higher order functions" do
    assert Calc.eval("plus = fun(x) { fun(y) { y + x } }; plustwo = plus(2); plustwo(5)") == 7
  end

  test "equals false" do
    assert Calc.eval("1 == 2") == 0
  end

  test "equals true" do
    assert Calc.eval("1 == 1") == 1
  end

  test "equals with plus" do
    assert Calc.eval("1 + 2 == 4 + 8") == 0
  end

  test "equals with ternary" do
    assert Calc.eval("1 == 2 ? 3 : 4") == 4
  end

  test "recursive function" do
    assert Calc.eval("factorial = fun(x) { x == 1 ? 1 : factorial(x - 1) * x }; factorial(4)") == 24
  end

  test "recursive function II" do
    assert Calc.eval("fib = fun(n) { run_fib(n, 0, 1) }; run_fib = fun(n, a, b) { n == 0 ? a : run_fib(n - 1, b, a + b) }; fib(10)") == 55
  end

  test "multiline program" do
    program = """
      a = 1
      b = 2
      a + b
    """
    assert Calc.eval(program) == 3
  end

  test "multiline program with function" do
    program = """
      fib = fun(n) {
        run_fib(n, 0, 1)
      }

      run_fib = fun(n, a, b) {
        n == 0 ?
          a :
          run_fib(n - 1, b, a + b)
      }

      fib(10)
    """
    assert Calc.eval(program) == 55
  end

  test "working with lists" do
    program = """
      count = fun(n) {
        do_count(1, n, [])
      }

      do_count = fun(next, max, acc) {
        next - 1 == max ?
          reverse(acc) :
          do_count(next + 1, max, unshift(acc, next))
      }

      count(10)
    """
    assert Calc.eval(program) == [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  end

  test "working wit lists II" do
    program = """
      factors = fun(n) {
        do_factors(n, 2, [])
      }

      do_factors = fun(n, i, acc) {
        sqrt(n) < i
          ?
            acc = unshift(acc, n)
            reverse(acc)
          :
            div = n / i
            div == floor(div) ?
              do_factors(n / i, i, unshift(acc, i)) :
              do_factors(n, i + 1, acc)
      }

      factors(6546546546)
    """
    assert Calc.eval(program) == [2, 3, 107, 149, 68437]
  end

  test "ternary operator with multiple expressions inside" do
    program = """
      1 ? a = 2; a : 45
    """
    assert Calc.eval(program) == 2
  end

  test "comparison" do
    assert Calc.eval("1 == 2") == 0
    assert Calc.eval("1 == 1") == 1
    assert Calc.eval("1 < 2") == 1
    assert Calc.eval("2 < 1") == 0
    assert Calc.eval("1 > 2") == 0
    assert Calc.eval("2 > 1") == 1
    assert Calc.eval("1 <= 2") == 1
    assert Calc.eval("2 <= 1") == 0
    assert Calc.eval("1 >= 2") == 0
    assert Calc.eval("2 >= 1") == 1
  end
end
