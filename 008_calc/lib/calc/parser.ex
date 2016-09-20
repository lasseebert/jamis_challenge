defmodule Calc.Parser do
  @moduledoc """
  Parser for simple arithmetics:

  expressions      = ternary more-expressions
  more_expressions = ';' expressions
                   | ()
  ternary = comparison
          | comparison : '?' ternary : ternary

  comparison = expression
             | expression compare-operator expression

  expression = term expression_operator expression
             | var '=' expression ;
             | 'fun' '(' var-list ')' '{' expressions  '}'

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
         | var '(' argument-list ')'
         | var
         | built_in '(' argument-list ')'
         | '[]'

  var-list = vars
           | ()
  vars = var
       | var ',' vars

  argument-list = arguments
                | ()
  arguments = expression
            | expression ',' arguments
  """

  def call(tokens) do
    with {:ok, expressions, []} <- parse_expressions(tokens) do
      {:ok, expressions}
    else
      {:ok, _expressions, rest} ->
        {:error, "Could not parse tail:", parse_expressions(rest)}
    end
  end

  # expressions      = ternary more-expressions
  defp parse_expressions(tokens) do
    with {:ok, ternary, rest} <- parse_ternary(tokens) do
      parse_more_expressions(rest, ternary)
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
    # Try to parse more expressions. If it is not valid, just use the one we have
    with {:ok, expressions, rest} <- parse_expressions(tokens) do
      {:ok, [expression | expressions], rest}
    else
      _ -> {:ok, [expression], tokens}
    end
  end

  # ternary = comparison
  #         | comparison : '?' ternary : ternary
  def parse_ternary(tokens) do
    with {:ok, expression, rest} <- parse_comparison(tokens) do
      case rest do
        [:ternary_true | rest] ->
          with {:ok, true_expressions, [:ternary_false | rest]} <- parse_expressions(rest),
               {:ok, false_expressions, rest} <- parse_expressions(rest) do
            {:ok, {:if, expression, true_expressions, false_expressions}, rest}
          else
            error -> {:error, "Error parsing ternary operator", error}
          end
        rest ->
          {:ok, expression, rest}
      end
    end
  end

  # comparison = expression
  #            | expression compare-operator expression
  def parse_comparison(tokens) do
    with {:ok, expression, rest} <- parse_expression(tokens) do
      case rest do
        [{:compare_operator, _} = compare_operator | rest] ->
          with {:ok, expression_2, rest} <- parse_expression(rest) do
            {:ok, {compare_operator, expression, expression_2}, rest}
          end
        rest ->
          {:ok, expression, rest}
      end
    end
  end

  # expression = term expression_operator expression
  #            | var '=' expression ;
  #            | 'fun' '(' var-list ')' '{' expressions  '}'
  defp parse_expression([{:var, _} = var, := | rest]) do
    with {:ok, expression, rest} <- parse_expression(rest) do
      {:ok, {:assign, var, expression}, rest}
    end
  end
  defp parse_expression([:fun_def, :lparen | rest]) do
    with {:ok, var_list, [:rparen, :fun_start | rest]} <- parse_var_list(rest),
         {:ok, expressions, [:fun_end | rest]} <- parse_expressions(rest) do
       {:ok, {:fun_def, var_list, expressions}, rest}
    else
      {:ok, _expressions, rest} -> {:error, "Function definition not parsed: #{rest |> inspect}"}
      error -> error
    end
  end
  defp parse_expression(tokens) do
    with {:ok, term, rest} <- parse_term(tokens) do
      case rest do
        [:+ | rest] ->
          with {:ok, expression, rest} <- parse_expression(rest) do
            {:ok, {{:operator, :+}, term, expression}, rest}
          end
        [:- | rest] ->
          with {:ok, expression, rest} <- parse_expression(rest) do
            {:ok, {{:operator, :-}, term, expression}, rest}
          end
        rest ->
          {:ok, term, rest}
      end
    end
  end

  # term    = exp term-op ;
  defp parse_term(tokens) do
    with {:ok, exp, rest} <- parse_exp(tokens) do
      parse_term_op(rest, exp)
    end
  end

  # factor = integer
  #        | '(' expression ')'
  #        | '-' factor ;
  #        | var '(' argument-list ')'
  #        | var
  #        | built_in '(' expression ')'
  #        | '[]'
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
      {:ok, {{:operator, :*}, {:integer, -1}, factor}, rest}
    end
  end
  defp parse_factor([{:var, _} = var, :lparen | rest]) do
    with {:ok, arguments, [:rparen | rest]} <- parse_argument_list(rest) do
      {:ok, {:fun_call, var, arguments}, rest}
    else
      {:ok, _, rest} -> {:error, "Missing right parenthesis in function call", rest}
      error -> error
    end
  end
  defp parse_factor([{:var, _} = var | rest]) do
    {:ok, var, rest}
  end
  defp parse_factor([{:built_in, _} = built_in, :lparen | rest]) do
    with {:ok, arguments, [:rparen | rest]} <- parse_argument_list(rest) do
      {:ok, {built_in, arguments}, rest}
    else
      {:ok, _expression, _rest} -> {:error, "Missing right parenthesis for built_in function #{built_in |> inspect}"}
      error -> error
    end
  end
  defp parse_factor([:empty_list | rest]) do
    {:ok, :empty_list, rest}
  end
  defp parse_factor(tokens) do
    {:error, "Error parsing factor in #{tokens |> inspect}"}
  end

  # term-op = '\*' term
  #         | '/' term
  #         | () ;
  defp parse_term_op([:* | rest], factor) do
    with {:ok, term, rest} <- parse_term(rest) do
      {:ok, {{:operator, :*}, factor, term}, rest}
    end
  end
  defp parse_term_op([:/ | rest], factor) do
    with {:ok, term, rest} <- parse_term(rest) do
      {:ok, {{:operator, :/}, factor, term}, rest}
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
      {:ok, {{:operator, :^}, factor, exp}, rest}
    end
  end
  defp parse_exp_op(tokens, factor) do
    {:ok, factor, tokens}
  end

  # var-list = vars
  #          | ()
  def parse_var_list([{:var, _} | _rest] = tokens) do
    parse_vars(tokens)
  end
  def parse_var_list(tokens) do
    {:ok, [], tokens}
  end

  # vars = var
  #      | var ',' vars
  def parse_vars([{:var, _} = var, :comma | rest]) do
    with {:ok, next_vars, rest} <- parse_vars(rest) do
      {:ok, [var | next_vars], rest}
    end
  end
  def parse_vars([{:var, _} = var | rest]) do
    {:ok, [var], rest}
  end
  def parse_vars(tokens) do
    {:error, "Expected vars", tokens}
  end

  # argument-list = arguments
  #               | ()
  def parse_argument_list([:rparen | _rest] = tokens) do
    {:ok, [], tokens}
  end
  def parse_argument_list(tokens) do
    parse_arguments(tokens)
  end

  # arguments = expression
  #           | expression ',' arguments
  def parse_arguments(tokens) do
    with {:ok, expression, rest} <- parse_expression(tokens) do
      case rest do
        [:comma | rest] ->
          with {:ok, next_arguments, rest} <- parse_arguments(rest) do
            {:ok, [expression | next_arguments], rest}
          end
        rest ->
          {:ok, [expression], rest}
      end
    end
  end
end
