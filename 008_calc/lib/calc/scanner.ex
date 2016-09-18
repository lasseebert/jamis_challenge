defmodule Calc.Scanner do
  @moduledoc """
  Splits a string into tokens
  """

  def call(input) do
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

  defp scan_next("^" <> rest) do
    {:^, rest}
  end

  defp scan_next("=" <> rest) do
    {:=, rest}
  end

  defp scan_next(";" <> rest) do
    {:end, rest}
  end

  defp scan_next("?" <> rest) do
    {:ternary_true, rest}
  end

  defp scan_next(":" <> rest) do
    {:ternary_false, rest}
  end

  defp scan_next("fun" <> rest) do
    {:fun_def, rest}
  end

  defp scan_next("{" <> rest) do
    {:fun_start, rest}
  end

  defp scan_next("}" <> rest) do
    {:fun_end, rest}
  end

  defp scan_next("," <> rest) do
    {:comma, rest}
  end

  defp scan_next("cos" <> rest) do
    {{:built_in, :cos}, rest}
  end

  defp scan_next("sin" <> rest) do
    {{:built_in, :sin}, rest}
  end

  defp scan_next(input) do
    cond do
      Regex.match?(~r/^[0-9]+/, input) ->
        [_, integer_string, rest] = Regex.run(~r/^([0-9]+)(.*)/, input)
        integer = String.to_integer(integer_string)
        {{:integer, integer}, rest}
      Regex.match?(~r/^[a-z]+/, input) ->
        [_, var_name, rest] = Regex.run(~r/^([a-z]+)(.*)/, input)
        {{:var, var_name}, rest}
      true ->
        {input, ""}
    end
  end
end
