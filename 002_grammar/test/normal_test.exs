defmodule Grammar.NormalTest do
  use ExUnit.Case

  alias Grammar.Normal

  test "it generates something" do
    name = Normal.generate
    assert name
  end
end
