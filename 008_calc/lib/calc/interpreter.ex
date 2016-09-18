defmodule Calc.Interpreter do
  def call(asts) do

    state = %{}
    eval_multi(asts, state, nil)
  end

  defp eval_multi([], _state, last_value) do
    {:ok, last_value}
  end
  defp eval_multi([first | rest], state, _) do
    with {:ok, result, state} <- eval(first, state) do
      eval_multi(rest, state, result)
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

  defp eval({:fun_def, {:var, param_name}, expr}, state) do
    {:ok, {:fun, param_name, expr}, state}
  end

  defp eval({:fun_call, {:var, fun_name}, value}, state) do
    case Map.has_key?(state, fun_name) do
      true ->
        with {:ok, value, state} <- eval(value, state),
             {:fun, param_name, expression} <- Map.get(state, fun_name) do
          fun_state = Map.put(state, param_name, value)
          eval(expression, fun_state)
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
