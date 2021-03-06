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

  defp eval({{:operator, operator}, left, right}, state) do
    with {:ok, left, state} <- eval(left, state),
         {:ok, right, state} <- eval(right, state) do
           {:ok, operate(operator, left, right), state}
         end
  end

  defp eval({{:compare_operator, operator}, left, right}, state) do
    with {:ok, left, state} <- eval(left, state),
         {:ok, right, state} <- eval(right, state) do
           {:ok, (if compare(operator, left, right), do: 1, else: 0), state}
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

  defp eval({:if, expr, true_exprs, false_exprs}, state) do
    with {:ok, expr, state} <- eval(expr, state) do
      if expr == 0 do
        eval_multi(false_exprs, state)
      else
        eval_multi(true_exprs, state)
      end
    end
  end

  defp eval({{:built_in, name}, arguments}, state) do
    with {:ok, arguments, state} <- eval_all(arguments, state) do
      {:ok, built_in(name, arguments), state}
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
          # Copy current state to fun state
          fun_state = Map.merge(state, fun_state)

          # Add arguments to state of the inner function
          params = Enum.zip(param_names, arguments)
          fun_state = Enum.reduce(params, fun_state, fn {{:var, param_name}, value}, state ->
            Map.put(state, param_name, value)
          end)

          # Evaluate function content in function state
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

  defp eval(:empty_list, state) do
    {:ok, [], state}
  end

  defp built_in(:cos, [value]), do: :math.cos(value)
  defp built_in(:floor, [value]), do: trunc(value)
  defp built_in(:print, [value]), do: IO.inspect(value)
  defp built_in(:reverse, [list]), do: list |> Enum.reverse
  defp built_in(:sin, [value]), do: :math.sin(value)
  defp built_in(:sqrt, [value]), do: :math.sqrt(value)
  defp built_in(:unshift, [list, value]), do: [value | list]

  defp compare(:==, left, right), do: left == right
  defp compare(:<, left, right), do: left < right
  defp compare(:>, left, right), do: left > right
  defp compare(:<=, left, right), do: left <= right
  defp compare(:>=, left, right), do: left >= right

  defp operate(:+, left, right), do: left + right
  defp operate(:-, left, right), do: left - right
  defp operate(:*, left, right), do: left * right
  defp operate(:/, left, right), do: left / right
  defp operate(:^, left, right), do: :math.pow(left, right)
end
