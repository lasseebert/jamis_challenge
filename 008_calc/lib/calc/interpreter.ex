defmodule Calc.Interpreter do
  def call(asts) do

    state = %{}
    eval_multi(asts, state, nil)
  end

  defp eval_multi(expressions, state, last_value \\ nil)
  defp eval_multi([], _state, last_value) do
    {:ok, last_value}
  end
  defp eval_multi([first | rest], state, _) do
    with {:ok, result, state} <- eval(first, state) do
      eval_multi(rest, state, result)
    end
  end

  defp eval_all(expression, state, acc \\ [])
  defp eval_all([], state, acc) do
    {:ok, acc |> Enum.reverse, state}
  end

  defp eval_all([first | rest], state, acc) do
    with {:ok, value, state} <- eval(first, state) do
      eval_all(rest, state, [value | acc])
    end
  end

  defp eval({:integer, integer}, state) do
    {:ok, integer, state}
  end

  defp eval({:+, left, right}, state) do
    with {:ok, left, state} <- eval(left, state),
         {:ok, right, state} <- eval(right, state) do
           {:ok, left + right, state}
         end
  end

  defp eval({:-, left, right}, state) do
    with {:ok, left, state} <- eval(left, state),
         {:ok, right, state} <- eval(right, state) do
           {:ok, left - right, state}
         end
  end

  defp eval({:*, left, right}, state) do
    with {:ok, left, state} <- eval(left, state),
         {:ok, right, state} <- eval(right, state) do
           {:ok, left * right, state}
         end
  end

  defp eval({:/, left, right}, state) do
    with {:ok, left, state} <- eval(left, state),
         {:ok, right, state} <- eval(right, state) do
           {:ok, left / right, state}
         end
  end

  defp eval({:^, left, right}, state) do
    with {:ok, left, state} <- eval(left, state),
         {:ok, right, state} <- eval(right, state) do
           {:ok, :math.pow(left, right), state}
         end
  end

  defp eval({:assign, {:var, name}, expression}, state) do
    with {:ok, value, state} <- eval(expression, state) do
      state = Map.put(state, name, value)
      {:ok, value, state}
    end
  end

  defp eval({:var, name}, state) do
    case Map.has_key?(state, name) do
      true -> {:ok, Map.get(state, name), state}
      false -> {:error, "Variable #{name} is undefined"}
    end
  end

  defp eval({:if, expr, true_expr, false_expr}, state) do
    with {:ok, expr, state} <- eval(expr, state) do
      if expr == 0 do
        eval(false_expr, state)
      else
        eval(true_expr, state)
      end
    end
  end

  defp eval({{:built_in, name}, expression}, state) do
    with {:ok, expression, state} <- eval(expression, state) do
      {:ok, built_in(name, expression), state}
    end
  end

  defp eval({:fun_def, argument_names, expr}, state) do
    {:ok, {:fun, argument_names, expr, state}, state}
  end

  defp eval({:fun_call, {:var, fun_name}, arguments}, state) do
    case Map.has_key?(state, fun_name) do
      true ->
        with {:ok, arguments, state} <- eval_all(arguments, state),
             {:fun, param_names, expressions, fun_state} <- Map.get(state, fun_name) do
          params = Enum.zip(param_names, arguments)
          fun_state = Enum.reduce(params, fun_state, fn {{:var, param_name}, value}, state ->
            Map.put(state, param_name, value)
          end)
          with {:ok, result} <- eval_multi(expressions, fun_state) do
            {:ok, result, state}
          end
        else
          error -> {:error, "Error evaluation function", error}
        end
      false ->
        {:error, "Function #{fun_name} is undefined"}
    end
  end

  defp built_in(:cos, value), do: :math.cos(value)
  defp built_in(:sin, value), do: :math.sin(value)
end
