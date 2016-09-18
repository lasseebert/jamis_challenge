defmodule Calc do
  alias Calc.Scanner
  alias Calc.Parser
  alias Calc.Interpreter

  def eval(input) do
    with tokens <- Scanner.call(input),
         {:ok, ast} <- Parser.call(tokens),
         result <- Interpreter.call(ast),
         do: result
  end
end
