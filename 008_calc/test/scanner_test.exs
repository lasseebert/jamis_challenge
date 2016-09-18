defmodule Calc.ScannerTest do
  use ExUnit.Case

  alias Calc.Scanner

  test "scanning a single digit" do
    assert Scanner.call("5") == [{:integer, 5}]
  end

  test "scanning a larger integer" do
    assert Scanner.call("50") == [{:integer, 50}]
  end

  test "scanning a small expression" do
    assert Scanner.call("1 + 3") == [{:integer, 1}, :+, {:integer, 3}]
  end

  test "scanning different tokens" do
    assert Scanner.call("+ - * / () 123") == [:+, :-, :*, :/, :lparen, :rparen, {:integer, 123}]
  end
end
