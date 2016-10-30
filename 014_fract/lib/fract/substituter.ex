defmodule Fract.Substituter do
  def run(start, _rules, 0) do
    start
  end
  def run(start, rules, count) do
    substitute(start, rules, "")
    |> run(rules, count - 1)
  end

  defp substitute("", _rules, acc) do
    acc
  end
  defp substitute(start, rules, acc) do
    {char, rest} = start |> String.next_grapheme

    acc = acc <> Map.get(rules, char, char)
    substitute(rest, rules, acc)
  end
end
