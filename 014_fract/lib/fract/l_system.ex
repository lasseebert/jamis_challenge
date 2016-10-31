defmodule Fract.LSystem do
  @moduledoc """
  Represents an L-System
  https://en.wikipedia.org/wiki/L-system

  F means "Move forward 1 unit"
  + means "Turn angle degrees clockwise"
  - means "Turn angle degrees counter-clockwise"
  """

  defmodule System do
    defstruct [
      angle: 0,
      start: "",
      rules: %{}
    ]
  end

  defmodule TurtleInstructions do
    defstruct [
      path: "",
      angle: 0
    ]
  end

  def turtle_instructions(system, count) when count > 0 do
    path =
      Stream.unfold(system.start, fn
        "" ->
          nil
        path ->
          {first, rest} = String.next_grapheme(path)
          {Map.get(system.rules, first, first), rest}
      end)
      |> Enum.join
    turtle_instructions(%{system | start: path}, count - 1)
  end
  def turtle_instructions(system, 0) do
    %TurtleInstructions{
      path: system.start,
      angle: system.angle
    }
  end

  @doc """
  The Dragon Curve
  https://en.wikipedia.org/wiki/Dragon_curve
  """
  def dragon_curve do
    %System{
      angle: 90,
      start: "FX",
      rules: %{
        "X" => "X+YF+",
        "Y" => "-FX-Y"
      }
    }
  end
end
