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
    assert Calc.eval("a = 1; myfun = fun(x) { a = 2 }; a") == 1
  end

  test "multiple expressions in function" do
    assert Calc.eval("myfun = fun(x) { y = 1; x + y }; myfun(4)") == 5
  end
end
