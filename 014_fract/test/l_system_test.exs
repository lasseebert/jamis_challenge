defmodule Fract.LSystemTest do
  use ExUnit.Case

  alias Fract.LSystem

  describe "turtle_instructions/2" do
    test "1 iteration" do
      insttructions =
        LSystem.dragon_curve
        |> LSystem.turtle_instructions(1)

      assert insttructions.path == "FX+YF+"
      assert insttructions.angle == 90
    end

    test "substitute three times" do
      insttructions =
        LSystem.dragon_curve
        |> LSystem.turtle_instructions(3)

      assert insttructions.path == "FX+YF++-FX-YF++-FX+YF+--FX-YF+"
    end
  end
end
