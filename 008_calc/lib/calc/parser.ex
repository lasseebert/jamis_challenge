defmodule Calc.Parser do
  @moduledoc """
  Parser for simple arithmetics:

  expressions      = expression more-expressions
  more_expressions = ';' expressions
                   | ()
  expression = term expr-op
             | var '=' expression ;
  expr-op    = '+' expression
             | '-' expression
             | '?' expression ':' expression
             | () ;

  term    = exp term-op ;
  term-op = '\*' term
          | '/' term
          | () ;

  exp    = factor exp-op ;
  exp-op = '^' exp
         | () ;

  factor = integer
         | '(' expression ')'
         | '-' factor ;
         | var
  """

  def call(tokens) do
    with {:ok, expressions, []} <- parse_expressions(tokens) do
      {:ok, expressions}
    else
      {:ok, _expressions, rest} -> {:error, "Tail not parsed: #{rest |> inspect}"}
      error -> error
    end
  end

  # expressions      = expression more-expressions
  defp parse_expressions(tokens) do
    with {:ok, expression, rest} <- parse_expression(tokens) do
      parse_more_expressions(rest, expression)
    end
  end

  # more_expressions = ';' expressions
  #                  | ()
  defp parse_more_expressions([:end | rest], expression) do
    with {:ok, expressions, rest} <- parse_expressions(rest) do
      {:ok, [expression | expressions], rest}
    end
  end
  defp parse_more_expressions(tokens, expression) do
    {:ok, [expression], tokens}
  end

  # expression = term expr-op
  #            | var '=' expression ;
  defp parse_expression([{:var, _} = var, := | rest]) do
    with {:ok, expression, rest} <- parse_expression(rest) do
      {:ok, {:assign, var, expression}, rest}
    end
  end
  defp parse_expression(tokens) do
    with {:ok, term, rest} <- parse_term(tokens) do
      parse_expr_op(rest, term)
    end
  end

  # term    = exp term-op ;
  defp parse_term(tokens) do
    with {:ok, exp, rest} <- parse_exp(tokens) do
      parse_term_op(rest, exp)
    end
  end

  # expr-op    = '+' expression
  #            | '-' expression
  #            | '?' expression ':' expression
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
  defp parse_expr_op([:ternary_true | rest], term) do
    with {:ok, true_expression, [:ternary_false | rest]} <- parse_expression(rest),
         {:ok, false_expression, rest} <- parse_expression(rest) do
      {:ok, {:if, term, true_expression, false_expression}, rest}
    else
      error -> {:error, "Error parsing ternary operator", error}
    end
  end
  defp parse_expr_op(tokens, term) do
    {:ok, term, tokens}
  end

  # factor = integer
  #        | '(' expression ')'
  #        | '-' factor ;
  #        | var
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
  defp parse_factor([{:var, _} = var | rest]) do
    {:ok, var, rest}
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

  # exp    = factor exp-op ;
  defp parse_exp(tokens) do
    with {:ok, factor, rest} <- parse_factor(tokens) do
      parse_exp_op(rest, factor)
    end
  end

  # exp-op = '^' exp
  #        | () ;
  defp parse_exp_op([:^ | rest], factor) do
    with {:ok, exp, rest} <- parse_exp(rest) do
      {:ok, {:^, factor, exp}, rest}
    end
  end
  defp parse_exp_op(tokens, factor) do
    {:ok, factor, tokens}
  end
end
