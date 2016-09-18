defmodule Calc.Interpreter do
  def call({:integer, integer}) do
    integer
  end

  def call({:+, left, right}) do
    call(left) + call(right)
  end

  def call({:-, left, right}) do
    call(left) - call(right)
  end

  def call({:/, left, right}) do
    call(left) / call(right)
  end

  def call({:*, left, right}) do
    call(left) * call(right)
  end
end
