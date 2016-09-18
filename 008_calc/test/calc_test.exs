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
end
