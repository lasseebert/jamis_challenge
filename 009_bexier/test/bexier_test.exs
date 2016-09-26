defmodule BexierTest do
  use ExUnit.Case

  test "computing a single point" do
    assert Bexier.quadratic({{0, 0}, {0, 100}, {100, 100}}, 0.5) == {25, 75}
  end
end
