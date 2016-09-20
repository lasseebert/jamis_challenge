defmodule Calc.ParserTest do
  use ExUnit.Case

  alias Calc.Scanner
  alias Calc.Parser

  test "simple plus statement" do
    assert Scanner.call("1 + 2") |> Parser.call == {
     :ok,
     [{{:operator, :+}, {:integer, 1}, {:integer, 2}}]
    }
  end

  test "multiple additions" do
    assert Scanner.call("1 + 2 + 3") |> Parser.call == {
     :ok,
     [{{:operator, :+}, {:integer, 1}, {{:operator, :+}, {:integer, 2}, {:integer, 3}}}]
    }
  end

  test "simple multiplication" do
    assert Scanner.call("1 * 2") |> Parser.call == {
     :ok,
     [{:*, {:integer, 1}, {:integer, 2}}]
    }
  end

  test "all simple operations" do
    assert Scanner.call("((((5)+2)*2)-5)/3") |> Parser.call == {
      :ok,
      [{
        :/,
        {
          {:operator, :-},
          {
            :*,
            {
              {:operator, :+},
              {:integer, 5},
              {:integer, 2}
            },
            {:integer, 2}
          },
          {:integer, 5}
        },
        {:integer, 3}
      }]
    }
  end

  test "calling built-in function with more than one argument" do
    program = "unshift([], 2)"
    tokens = Scanner.call(program)
    assert Parser.call(tokens) == {:ok, [{{:built_in, :unshift}, [:empty_list, {:integer, 2}]}]}
  end
end
