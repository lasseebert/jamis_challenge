defmodule Calc.Scanner do
  @moduledoc """
  Splits a string into tokens
  """

  @digits ~w(0 1 2 3 4 5 6 7 8 9)

  def scan(input) do
    Stream.unfold(input, &scan_next/1)
    |> Enum.to_list
  end

  defp scan_next("") do
    nil
  end

  defp scan_next(" " <> rest) do
    scan_next(rest)
  end

  defp scan_next("+" <> rest) do
    {:+, rest}
  end

  defp scan_next("-" <> rest) do
    {:-, rest}
  end

  defp scan_next("*" <> rest) do
    {:*, rest}
  end

  defp scan_next("/" <> rest) do
    {:/, rest}
  end

  defp scan_next("(" <> rest) do
    {:lparen, rest}
  end

  defp scan_next(")" <> rest) do
    {:rparen, rest}
  end

  defp scan_next(<<digit::binary-1, _rest::binary>> = input) when digit in @digits do
    [_, integer_string, rest] = Regex.run(~r/^([0-9]+)(.*)/, input)
    integer = String.to_integer(integer_string)
    {{:integer, integer}, rest}
  end
end
