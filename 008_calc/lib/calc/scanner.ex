defmodule Calc.Scanner do
  @moduledoc """
  Splits a string into tokens
  """

  @built_in_functions ~w(
    cos
    floor
    print
    reverse
    sin
    sqrt
    unshift
  )

  @terminals [
    {"+", :+},
    {"-", :-},
    {"*", :*},
    {"/", :/},
    {"(", :lparen},
    {")", :rparen},
    {"^", :^},
    {"==", :==},
    {"=", :=},
    {"<", :<},
    {";", :end},
    {"?", :ternary_true},
    {":", :ternary_false},
    {"fun", :fun_def},
    {"{", :fun_start},
    {"}", :fun_end},
    {",", :comma},
    {"[]", :empty_list}
  ]

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
  defp scan_next("\n" <> rest) do
    scan_next(rest)
  end

  for {key, value} <- @terminals do
    defp scan_next(unquote(key) <> rest) do
      {unquote(value), rest}
    end
  end

  for name <- @built_in_functions do
    defp scan_next(unquote(name) <> rest) do
      {{:built_in, unquote(name)}, rest}
    end
  end

  defp scan_next(input) do
    cond do
      # Integers
      Regex.match?(~r/^[0-9]+/, input) ->
        [_, integer_string, rest] = Regex.run(~r/^([0-9]+)(.*)/sm, input)
        integer = String.to_integer(integer_string)
        {{:integer, integer}, rest}

      # Variable names
      Regex.match?(~r/^[a-z]+/, input) ->
        [_, var_name, rest] = Regex.run(~r/^([a-z_0-9]+)(.*)/sm, input)
        {{:var, var_name}, rest}

      # Catch all
      true ->
        {input, ""}
    end
  end
end
