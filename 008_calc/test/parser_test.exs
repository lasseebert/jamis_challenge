defmodule Calc.ParserTest do
  use ExUnit.Case

  alias Calc.Scanner
  alias Calc.Parser

  test "simple plus statement" do
    assert Scanner.scan("1 + 2") |> Parser.call == {
     :ok,
     {:+, {:integer, 1}, {:integer, 2}}
    }
  end

  test "multiple additions" do
    assert Scanner.scan("1 + 2 + 3") |> Parser.call == {
     :ok,
     {:+, {:integer, 1}, {:+, {:integer, 2}, {:integer, 3}}}
    }
  end

  test "simple multiplication" do
    assert Scanner.scan("1 * 2") |> Parser.call == {
     :ok,
     {:*, {:integer, 1}, {:integer, 2}}
    }
  end

  test "all simple operations" do
    assert Scanner.scan("((((5)+2)*2)-5)/3") |> Parser.call == {
      :ok,
      {
        :/,
        {
          :-,
          {
            :*,
            {
              :+,
              {:integer, 5},
              {:integer, 2}
            },
            {:integer, 2}
          },
          {:integer, 5}
        },
        {:integer, 3}
      }
    }
  end
end
