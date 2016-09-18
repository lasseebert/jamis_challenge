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

  def eval({:integer, integer}, state) do
    {:ok, integer, state}
  end

  def eval({:+, left, right}, state) do
    with {:ok, left, state} <- eval(left, state),
         {:ok, right, state} <- eval(right, state) do
           {:ok, left + right, state}
         end
  end

  def eval({:-, left, right}, state) do
    with {:ok, left, state} <- eval(left, state),
         {:ok, right, state} <- eval(right, state) do
           {:ok, left - right, state}
         end
  end

  def eval({:*, left, right}, state) do
    with {:ok, left, state} <- eval(left, state),
         {:ok, right, state} <- eval(right, state) do
           {:ok, left * right, state}
         end
  end

  def eval({:/, left, right}, state) do
    with {:ok, left, state} <- eval(left, state),
         {:ok, right, state} <- eval(right, state) do
           {:ok, left / right, state}
         end
  end

  def eval({:^, left, right}, state) do
    with {:ok, left, state} <- eval(left, state),
         {:ok, right, state} <- eval(right, state) do
           {:ok, :math.pow(left, right), state}
         end
  end

  def eval({:assign, {:var, name}, expression}, state) do
    with {:ok, value, state} <- eval(expression, state) do
      state = Map.put(state, name, value)
      {:ok, value, state}
    end
  end

  def eval({:var, name}, state) do
    case Map.has_key?(state, name) do
      true -> {:ok, Map.get(state, name), state}
      false -> {:error, "Variable #{name} is undefined"}
    end
  end

  def eval({:if, expr, true_expr, false_expr}, state) do
    with {:ok, expr, state} <- eval(expr, state),
         {:ok, true_expr, state} <- eval(true_expr, state),
         {:ok, false_expr, state} <- eval(false_expr, state) do
      if expr == 0 do
        {:ok, false_expr, state}
      else
        {:ok, true_expr, state}
      end
    end
  end
end
