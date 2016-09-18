defmodule Calc.Parser do
  @moduledoc """
  Parser for simple arithmetics:

  expression = term expr-op ;
  expr-op    = '+' expression
             | '-' expression
             | () ;

  term    = factor term-op ;
  term-op = '\*' term
          | '/' term
          | () ;

  factor = integer
         | '(' expression ')'
         | '-' factor ;
  """

  def call(tokens) do
    with {:ok, expression, []} <- parse_expression(tokens) do
      {:ok, expression}
    else
      {:ok, _expression, rest} -> {:error, "Tail not parsed: #{rest |> inspect}"}
      error -> error
    end
  end

  # expression = term expr-op ;
  defp parse_expression(tokens) do
    with {:ok, term, rest} <- parse_term(tokens) do
      parse_expr_op(rest, term)
    end
  end

  # term    = factor term-op ;
  defp parse_term(tokens) do
    with {:ok, factor, rest} <- parse_factor(tokens) do
      parse_term_op(rest, factor)
    end
  end

  # expr-op    = '+' expression
  #            | '-' expression
  #            | () ;
  defp parse_expr_op([:+ | rest], term) do
    with {:ok, expression, rest} <- parse_expression(rest) do
      {:ok, {:+, term, expression}, rest}
    end
  end
  defp parse_expr_op([:- | rest], term) do
    with {:ok, expression, rest} <- parse_expression(rest) do
      {:ok, {:-, term, expression}, rest}
    end
  end
  defp parse_expr_op(tokens, term) do
    {:ok, term, tokens}
  end

  # factor = integer
  #        | '(' expression ')'
  #        | '-' factor ;
  defp parse_factor([{:integer, _} = integer | rest]) do
    {:ok, integer, rest}
  end
  defp parse_factor([:lparen | rest]) do
    with {:ok, expression, [:rparen | rest]} <- parse_expression(rest) do
      {:ok, expression, rest}
    else
      {:ok, _expression, _rest} -> {:error, "Missing right parenthesis"}
      error -> error
    end
  end
  defp parse_factor([:- | rest]) do
    with {:ok, factor, rest} <- parse_factor(rest) do
      {:ok, {:*, {:integer, -1}, factor}, rest}
    end
  end
  defp parse_factor(tokens) do
    {:error, "Error parsing factor in #{tokens |> inspect}"}
  end

  # term-op = '\*' term
  #         | '/' term
  #         | () ;
  defp parse_term_op([:* | rest], factor) do
    with {:ok, term, rest} <- parse_term(rest) do
      {:ok, {:*, factor, term}, rest}
    end
  end
  defp parse_term_op([:/ | rest], factor) do
    with {:ok, term, rest} <- parse_term(rest) do
      {:ok, {:/, factor, term}, rest}
    end
  end
  defp parse_term_op(tokens, factor) do
    {:ok, factor, tokens}
  end
end
