defmodule Fract.SubstituterTest do
  use ExUnit.Case

  alias Fract.Substituter

  test "substitute one time" do
    start = "FX"
    rules = %{
      "X" => "X+YF+",
      "Y" => "-FX-Y"
    }

    assert Substituter.run(start, rules, 1) == "FX+YF+"
  end

  test "substitute three times" do
    start = "FX"
    rules = %{
      "X" => "X+YF+",
      "Y" => "-FX-Y"
    }

    assert Substituter.run(start, rules, 3) == "FX+YF++-FX-YF++-FX+YF+--FX-YF+"
  end
end
